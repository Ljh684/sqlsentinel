///|
/// Internal token categories. They are intentionally small: SQLSentinel
/// performs conservative structural checks rather than dialect-specific parsing.
priv enum TokenKind {
  Word
  StringLiteral
  QuotedIdentifier
  Number
  Symbol
} derive(Eq)

///|
/// One lexical token with a 1-based source location.
priv struct Token {
  kind : TokenKind
  text : String
  value : String
  line : Int
  column : Int
}

///|
fn is_word_start(ch : Char) -> Bool {
  ch.is_ascii_alphabetic() || ch == '_'
}

///|
fn is_word_part(ch : Char) -> Bool {
  ch.is_ascii_alphabetic() || ch.is_ascii_digit() || ch == '_' || ch == '$'
}

///|
fn is_identifier_quote(ch : Char) -> Bool {
  ch == '"' || ch == '`' || ch == '['
}

///|
fn identifier_quote_end(ch : Char) -> Char {
  match ch {
    '[' => ']'
    other => other
  }
}

///|
fn read_quoted_identifier(chars : Array[Char], start : Int) -> (Int, String) {
  let open = chars[start]
  let close = identifier_quote_end(open)
  let builder = StringBuilder()
  let mut i = start + 1
  while i < chars.length() {
    let ch = chars[i]
    if ch == close {
      if close != ']' && i + 1 < chars.length() && chars[i + 1] == close {
        builder.write_char(close)
        i = i + 2
      } else {
        return (i + 1, builder.to_string())
      }
    } else {
      builder.write_char(ch)
      i = i + 1
    }
  }
  (i, builder.to_string())
}

///|
fn read_string_literal(chars : Array[Char], start : Int) -> (Int, String) {
  let builder = StringBuilder()
  let mut i = start + 1
  while i < chars.length() {
    let ch = chars[i]
    if ch == '\'' {
      if i + 1 < chars.length() && chars[i + 1] == '\'' {
        builder.write_char('\'')
        i = i + 2
      } else {
        return (i + 1, builder.to_string())
      }
    } else if ch == '\\' && i + 1 < chars.length() {
      builder.write_char(chars[i + 1])
      i = i + 2
    } else {
      builder.write_char(ch)
      i = i + 1
    }
  }
  (i, builder.to_string())
}

///|
fn dollar_delimiter(chars : Array[Char], start : Int) -> String? {
  let mut i = start + 1
  while i < chars.length() {
    let ch = chars[i]
    if ch == '$' {
      return Some(String::from_array(chars[start:i + 1]))
    }
    if !(ch.is_ascii_alphabetic() || ch.is_ascii_digit() || ch == '_') {
      return None
    }
    i = i + 1
  }
  None
}

///|
fn read_dollar_string(
  chars : Array[Char],
  start : Int,
  delimiter : String,
) -> (Int, String) {
  let delimiter_chars = delimiter.to_array()
  let body_start = start + delimiter_chars.length()
  let mut i = body_start
  while i + delimiter_chars.length() <= chars.length() {
    let mut matches = true
    for j in 0..<delimiter_chars.length() {
      if chars[i + j] != delimiter_chars[j] {
        matches = false
        break
      }
    }
    if matches {
      return (
        i + delimiter_chars.length(),
        String::from_array(chars[body_start:i]),
      )
    }
    i = i + 1
  }
  (chars.length(), String::from_array(chars[body_start:chars.length()]))
}

///|
fn tokenize(source : String) -> Array[Token] {
  let chars = source.to_array()
  let tokens = []
  let mut i = 0
  let mut line = 1
  let mut column = 1
  while i < chars.length() {
    let ch = chars[i]
    if ch == '\n' {
      line = line + 1
      column = 1
      i = i + 1
      continue
    }
    if ch.is_whitespace() {
      i = i + 1
      column = column + 1
      continue
    }
    if ch == '-' && i + 1 < chars.length() && chars[i + 1] == '-' {
      while i < chars.length() && chars[i] != '\n' {
        i = i + 1
        column = column + 1
      }
      continue
    }
    if ch == '#' && !(i + 1 < chars.length() && chars[i + 1] == '>') {
      while i < chars.length() && chars[i] != '\n' {
        i = i + 1
        column = column + 1
      }
      continue
    }
    if ch == '/' && i + 1 < chars.length() && chars[i + 1] == '*' {
      let mut depth = 1
      i = i + 2
      column = column + 2
      while i < chars.length() && depth > 0 {
        if i + 1 < chars.length() && chars[i] == '/' && chars[i + 1] == '*' {
          depth = depth + 1
          i = i + 2
          column = column + 2
        } else if chars[i] == '*' &&
          i + 1 < chars.length() &&
          chars[i + 1] == '/' {
          depth = depth - 1
          i = i + 2
          column = column + 2
        } else if chars[i] == '\n' {
          line = line + 1
          column = 1
          i = i + 1
        } else {
          i = i + 1
          column = column + 1
        }
      }
      continue
    }

    let token_line = line
    let token_column = column
    if is_word_start(ch) {
      let start = i
      while i < chars.length() && is_word_part(chars[i]) {
        i = i + 1
        column = column + 1
      }
      let text = String::from_array(chars[start:i])
      tokens.push({
        kind: Word,
        text,
        value: text.to_upper(),
        line: token_line,
        column: token_column,
      })
      continue
    }
    if ch == '\'' {
      let (next, value) = read_string_literal(chars, i)
      let length = next - i
      i = next
      column = column + length
      tokens.push({
        kind: StringLiteral,
        text: "'<literal>'",
        value,
        line: token_line,
        column: token_column,
      })
      continue
    }
    if is_identifier_quote(ch) {
      let (next, value) = read_quoted_identifier(chars, i)
      let length = next - i
      i = next
      column = column + length
      tokens.push({
        kind: QuotedIdentifier,
        text: String::from_array(chars[i - length:i]),
        value,
        line: token_line,
        column: token_column,
      })
      continue
    }
    if ch == '$' {
      match dollar_delimiter(chars, i) {
        Some(delimiter) => {
          let (next, value) = read_dollar_string(chars, i, delimiter)
          let length = next - i
          i = next
          column = column + length
          tokens.push({
            kind: StringLiteral,
            text: "$<literal>$",
            value,
            line: token_line,
            column: token_column,
          })
          continue
        }
        None => ()
      }
    }
    if ch.is_ascii_digit() {
      let start = i
      while i < chars.length() &&
            (
              chars[i].is_ascii_digit() ||
              chars[i] == '.' ||
              chars[i] == 'e' ||
              chars[i] == 'E' ||
              chars[i] == '+' ||
              chars[i] == '-'
            ) {
        i = i + 1
        column = column + 1
      }
      let text = String::from_array(chars[start:i])
      tokens.push({
        kind: Number,
        text,
        value: text,
        line: token_line,
        column: token_column,
      })
      continue
    }

    let mut symbol = ch.to_string()
    if i + 1 < chars.length() {
      let pair = String::from_array(chars[i:i + 2])
      match pair {
        "<=" | ">=" | "<>" | "!=" | "::" | "->" | "=>" | "||" | "&&" | "#>" => {
          symbol = pair
          i = i + 1
          column = column + 1
        }
        _ => ()
      }
    }
    tokens.push({
      kind: Symbol,
      text: symbol,
      value: symbol,
      line: token_line,
      column: token_column,
    })
    i = i + 1
    column = column + 1
  }
  tokens
}

///|
fn split_statements(tokens : Array[Token]) -> Array[Array[Token]] {
  let statements = []
  let mut current = []
  for token in tokens {
    if token.kind == Symbol && token.text == ";" {
      if !current.is_empty() {
        statements.push(current)
        current = []
      }
    } else {
      current.push(token)
    }
  }
  if !current.is_empty() {
    statements.push(current)
  }
  statements
}

///|
fn token_is_word(token : Token, word : String) -> Bool {
  token.kind == Word && token.value == word
}

///|
fn token_is_symbol(token : Token, symbol : String) -> Bool {
  token.kind == Symbol && token.text == symbol
}
