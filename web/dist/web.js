function _M0TP26Ljh68411sqlsentinel14RuleDefinition(param0, param1, param2, param3, param4) {
  this.id = param0;
  this.title = param1;
  this.severity = param2;
  this.rationale = param3;
  this.remediation = param4;
}
function _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Accepted(param0) {
  this._0 = param0;
}
_M0DTP26Ljh68411sqlsentinel15ParsedDirective8Accepted.prototype.$tag = 0;
function _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Rejected(param0) {
  this._0 = param0;
}
_M0DTP26Ljh68411sqlsentinel15ParsedDirective8Rejected.prototype.$tag = 1;
function _M0TPB13StringBuilder(param0) {
  this.val = param0;
}
class $PanicError extends Error {}
function $panic() {
  throw new $PanicError();
}
function _M0TPC16string10StringView(param0, param1, param2) {
  this.str = param0;
  this.start = param1;
  this.end = param2;
}
const _M0FPB12random__seed = () => {
  if (globalThis.crypto?.getRandomValues) {
    const array = new Uint32Array(1);
    globalThis.crypto.getRandomValues(array);
    return array[0] | 0; // Convert to signed 32
  } else {
    return Math.floor(Math.random() * 0x100000000) | 0; // Fallback to Math.random
  }
};
const _M0FPB19int__to__string__js = (x, radix) => {
  return x.toString(radix);
};
function _M0TPB4IterGUsRPB4JsonEE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB4IterGcE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function $oob() {
  throw new Error("Index out of bounds");
}
function _M0TPB8MutLocalGiE(param0) {
  this.val = param0;
}
function $make_array_len_and_init(a, b) {
  const arr = new Array(a);
  arr.fill(b);
  return arr;
}
const _M0MPB7JSArray4push = (arr, val) => { arr.push(val); };
function _M0TPB4IterGRPC16string10StringViewE(param0, param1) {
  this.f = param0;
  this.size_hint = param1;
}
function _M0TPB8MutLocalGORPC16string10StringViewE(param0) {
  this.val = param0;
}
function $compare_int(a, b) {
  return (a >= b) - (a <= b);
}
function _M0TPB3MapGsiE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB3MapGsRPB4JsonE(param0, param1, param2, param3, param4, param5, param6) {
  this.entries = param0;
  this.size = param1;
  this.capacity = param2;
  this.capacity_mask = param3;
  this.grow_at = param4;
  this.head = param5;
  this.tail = param6;
}
function _M0TPB5EntryGsiE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB5EntryGsRPB4JsonE(param0, param1, param2, param3, param4, param5) {
  this.prev = param0;
  this.next = param1;
  this.psl = param2;
  this.hash = param3;
  this.key = param4;
  this.value = param5;
}
function _M0TPB8MutLocalGORPB5EntryGsRPB4JsonEE(param0) {
  this.val = param0;
}
function _M0TPB8MutLocalGORPB5EntryGsiEE(param0) {
  this.val = param0;
}
function _M0TPB9ArrayViewGcE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
const _M0MPB7JSArray3pop = (arr) => arr.pop();
function _M0TPB12MutArrayViewGRP26Ljh68411sqlsentinel7FindingE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0DTPC14json10WriteFrame5Array(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC14json10WriteFrame5Array.prototype.$tag = 0;
function _M0DTPC14json10WriteFrame6Object(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPC14json10WriteFrame6Object.prototype.$tag = 1;
function _M0TP26Ljh68411sqlsentinel11ScanOptions(param0, param1, param2, param3) {
  this.allow_destructive = param0;
  this.style_checks = param1;
  this.ignored_rules = param2;
  this.dialect = param3;
}
function _M0DTPB4Json4Null() {}
_M0DTPB4Json4Null.prototype.$tag = 0;
const _M0DTPB4Json4Null__ = new _M0DTPB4Json4Null();
function _M0DTPB4Json4True() {}
_M0DTPB4Json4True.prototype.$tag = 1;
function _M0DTPB4Json5False() {}
_M0DTPB4Json5False.prototype.$tag = 2;
function _M0DTPB4Json6Number(param0, param1) {
  this._0 = param0;
  this._1 = param1;
}
_M0DTPB4Json6Number.prototype.$tag = 3;
function _M0DTPB4Json6String(param0) {
  this._0 = param0;
}
_M0DTPB4Json6String.prototype.$tag = 4;
function _M0DTPB4Json5Array(param0) {
  this._0 = param0;
}
_M0DTPB4Json5Array.prototype.$tag = 5;
function _M0DTPB4Json6Object(param0) {
  this._0 = param0;
}
_M0DTPB4Json6Object.prototype.$tag = 6;
function _M0TPB9ArrayViewGUsRPB4JsonEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP26Ljh68411sqlsentinel5Token(param0, param1, param2, param3, param4) {
  this.kind = param0;
  this.text = param1;
  this.value = param2;
  this.line = param3;
  this.column = param4;
}
function _M0TP26Ljh68411sqlsentinel7Finding(param0, param1, param2, param3, param4, param5, param6, param7, param8) {
  this.rule_id = param0;
  this.title = param1;
  this.severity = param2;
  this.message = param3;
  this.suggestion = param4;
  this.statement_index = param5;
  this.line = param6;
  this.column = param7;
  this.evidence = param8;
}
function _M0TP26Ljh68411sqlsentinel12InlineIgnore(param0, param1) {
  this.statement_index = param0;
  this.rule_ids = param1;
}
function _M0TPB9ArrayViewGUsiEE(param0, param1, param2) {
  this.buf = param0;
  this.start = param1;
  this.end = param2;
}
function _M0TP26Ljh68411sqlsentinel14SuppressedRule(param0, param1) {
  this.rule_id = param0;
  this.count = param1;
}
function _M0TP26Ljh68411sqlsentinel6Report(param0, param1, param2, param3, param4, param5, param6, param7) {
  this.statement_count = param0;
  this.findings = param1;
  this.error_count = param2;
  this.warning_count = param3;
  this.info_count = param4;
  this.suppressed_count = param5;
  this.suppressions = param6;
  this.dialect = param7;
}
function _M0DTPC16option6OptionGRPB5ArrayGsEE4None() {}
_M0DTPC16option6OptionGRPB5ArrayGsEE4None.prototype.$tag = 0;
const _M0DTPC16option6OptionGRPB5ArrayGsEE4None__ = new _M0DTPC16option6OptionGRPB5ArrayGsEE4None();
function _M0DTPC16option6OptionGRPB5ArrayGsEE4Some(param0) {
  this._0 = param0;
}
_M0DTPC16option6OptionGRPB5ArrayGsEE4Some.prototype.$tag = 1;
const _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger = { method_0: _M0IPB13StringBuilderPB6Logger13write__string, method_1: _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE, method_2: _M0IPB13StringBuilderPB6Logger11write__view, method_3: _M0IPB13StringBuilderPB6Logger11write__char, method_4: _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE, method_5: _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE };
const _M0MPC16string10StringView4trimN7_2abindS6831 = "\t\n\r ";
const _M0MPC16string6String11trim__startN7_2abindS6882 = "\t\n\r ";
const _M0MPC16string6String4trimN7_2abindS6932 = "\t\n\r ";
const _M0MPB4Iter4nextN6constrS9909GUsRPB4JsonEE = 0;
const _M0MPB4Iter4nextN6constrS9910GUsRPB4JsonEE = 0;
const _M0MPB4Iter4nextN6constrS9909GcE = 0;
const _M0MPB4Iter4nextN6constrS9910GcE = 0;
const _M0MPB4Iter3newN6constrS9917GUsRPB4JsonEE = 0;
const _M0MPB4Iter3newN6constrS9917GcE = 0;
const _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS541 = "|";
const _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS542 = "\\|";
const _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS543 = "\n";
const _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS544 = " ";
const _M0FP26Ljh68411sqlsentinel28report__to__markdown_2einnerN7_2abindS574 = "`";
const _M0FP26Ljh68411sqlsentinel28report__to__markdown_2einnerN7_2abindS575 = "'";
const _M0FP26Ljh68411sqlsentinel25directive__comment__tokenN7_2abindS650 = "sqlsentinel";
const _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN7_2abindS730 = ":";
const _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN7_2abindS724 = ",";
const _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS839 = "%";
const _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS840 = "\\%";
const _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS841 = "_";
const _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS842 = "\\_";
const _M0MP26Ljh68411sqlsentinel6Report17highest__severityN6constrS991 = 2;
const _M0MP26Ljh68411sqlsentinel6Report17highest__severityN6constrS992 = 1;
const _M0MP26Ljh68411sqlsentinel6Report17highest__severityN6constrS993 = 0;
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS994 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL001", "Unbounded data mutation", 2, "UPDATE or DELETE without a top-level WHERE clause, or with an always-true predicate, can modify every row in a table.", "Add a precise WHERE predicate. For an intentional full-table operation, use an explicit reviewed migration or dedicated maintenance path.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS995 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL002", "Destructive schema change", 2, "DROP TABLE, TRUNCATE, and DROP COLUMN remove or erase data and are difficult to reverse after deployment.", "Back up the affected data, use an expand-and-contract migration, and obtain an explicit destructive-change approval.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS996 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL003", "Wildcard projection", 1, "SELECT * couples callers to every column and can make schema changes silently break applications.", "List the columns that the caller actually consumes.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS997 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL004", "Non-deterministic pagination", 1, "LIMIT without ORDER BY gives the database freedom to return a different subset for the same query.", "Add a stable ORDER BY expression, preferably backed by a unique key.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS998 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL005", "Leading-wildcard LIKE", 1, "A LIKE pattern beginning with % or _ usually prevents an ordinary B-tree index from narrowing the scan.", "Use a prefix pattern where possible, or deliberately adopt a trigram or full-text index.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS999 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL006", "Comma join", 1, "Comma-separated tables hide the join condition and are easy to turn into an accidental cross join.", "Use explicit JOIN syntax and move the relationship predicate into ON.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS1000 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL007", "INSERT without a column list", 1, "Positional INSERT statements break when a column is inserted, reordered, or generated by a later schema change.", "Name every target column in the INSERT statement.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS1001 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL008", "NOT NULL column without a default", 1, "Adding a required column without a default can fail on existing rows or lock and rewrite a large table.", "Use a staged nullable/defaulted column migration, backfill data, then enforce NOT NULL.");
const _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS1002 = new _M0TP26Ljh68411sqlsentinel14RuleDefinition("SQL100", "Invalid SQLSentinel directive", 1, "A malformed or unreachable ignore directive can hide an intended review decision.", "Use `-- sqlsentinel: ignore SQL003,SQL004` immediately before a SQL statement and list known rule IDs.");
const _M0FP26Ljh68411sqlsentinel19statement__evidenceN6constrS1003 = 160;
const _M0MPC16string10StringView4findN6constrS9919 = 0;
const _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN6constrS1004 = new _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Rejected("directive must use the form 'sqlsentinel: ignore RULE'");
const _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN6constrS1005 = new _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Rejected("expected a comma-separated list of rule IDs");
const _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN6constrS1006 = new _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Rejected("ignore directive must name at least one rule");
const _M0FPB4seed = _M0FPB12random__seed();
const _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS983 = 3;
const _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS984 = 1;
const _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS985 = 0;
const _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS986 = 2;
function _M0FPB13consume4__acc(acc, input) {
  const _p = (acc >>> 0) + ((Math.imul(input, -1028477379) | 0) >>> 0) | 0;
  const _p$2 = 17;
  return Math.imul(_p << _p$2 | (_p >>> (32 - _p$2 | 0) | 0), 668265263) | 0;
}
function _M0MPB13StringBuilder13write__objectGsE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGsE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGiE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGiE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder13write__objectGdE(self, obj) {
  _M0IP016_24default__implPB4Show6outputGdE(obj, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPB13StringBuilder21StringBuilder_2einner(size_hint) {
  return new _M0TPB13StringBuilder("");
}
function _M0IPB13StringBuilderPB6Logger11write__char(self, ch) {
  self.val = `${self.val}${String.fromCodePoint(ch)}`;
}
function _M0IPB13StringBuilderPB6Logger13write__string(self, str) {
  self.val = `${self.val}${str}`;
}
function _M0MPC16string6String20char__length_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  if (start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= self.length)) {
    let _tmp = start_offset;
    let _tmp$2 = 0;
    while (true) {
      const utf16_index = _tmp;
      const char_count = _tmp$2;
      if (utf16_index < end_offset$2) {
        const c1 = self.charCodeAt(utf16_index);
        if (c1 >= 55296 && c1 <= 56319 && (utf16_index + 1 | 0) < end_offset$2) {
          const c2 = self.charCodeAt(utf16_index + 1 | 0);
          if (c2 >= 56320 && c2 <= 57343) {
            _tmp = utf16_index + 2 | 0;
            _tmp$2 = char_count + 1 | 0;
            continue;
          } else {
            $panic();
          }
        }
        _tmp = utf16_index + 1 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      } else {
        return char_count;
      }
    }
  } else {
    return $panic();
  }
}
function _M0FPB32code__point__of__surrogate__pair(leading, trailing) {
  return (((Math.imul(leading - 55296 | 0, 1024) | 0) + trailing | 0) - 56320 | 0) + 65536 | 0;
}
function _M0MPC16string6String16unsafe__char__at(self, index) {
  const c1 = self.charCodeAt(index);
  if (c1 >= 55296 && c1 <= 56319) {
    const c2 = self.charCodeAt(index + 1 | 0);
    return _M0FPB32code__point__of__surrogate__pair(c1, c2);
  } else {
    return c1;
  }
}
function _M0MPC14byte4Byte7to__hexN14to__hex__digitS4038(i) {
  if (i < 10) {
    const _p = 48;
    const _p$2 = (i + _p | 0) & 255;
    return _p$2;
  } else {
    const _p = 97;
    const _p$2 = (i + _p | 0) & 255;
    const _p$3 = 10;
    const _p$4 = (_p$2 - _p$3 | 0) & 255;
    return _p$4;
  }
}
function _M0MPC14byte4Byte7to__hex(b) {
  const _self = _M0MPB13StringBuilder21StringBuilder_2einner(0);
  const _p = 16;
  _M0IPB13StringBuilderPB6Logger11write__char(_self, _M0MPC14byte4Byte7to__hexN14to__hex__digitS4038((b / _p | 0) & 255));
  const _p$2 = 16;
  _M0IPB13StringBuilderPB6Logger11write__char(_self, _M0MPC14byte4Byte7to__hexN14to__hex__digitS4038((b % _p$2 | 0) & 255));
  const _p$3 = _self;
  return _p$3.val;
}
function _M0MPC16string10StringView12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.end - self.start | 0;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  if (start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= (self.end - self.start | 0))) {
    return new _M0TPC16string10StringView(self.str, self.start + start_offset | 0, self.start + end_offset$2 | 0);
  } else {
    return $panic();
  }
}
function _M0IP016_24default__implPB2Eq10not__equalGRP26Ljh68411sqlsentinel7DialectE(x, y) {
  return !_M0IP26Ljh68411sqlsentinel7DialectPB2Eq5equal(x, y);
}
function _M0FPB14avalanche__acc(acc) {
  let acc$2 = acc;
  acc$2 = acc$2 ^ (acc$2 >>> 15 | 0);
  acc$2 = Math.imul(acc$2, -2048144777) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 13 | 0);
  acc$2 = Math.imul(acc$2, -1028477379) | 0;
  acc$2 = acc$2 ^ (acc$2 >>> 16 | 0);
  return acc$2;
}
function _M0FPB13finalize__acc(acc) {
  return _M0FPB14avalanche__acc(acc);
}
function _M0IP016_24default__implPB6Logger28write__string__interpolationGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0IP016_24default__implPB6Logger5writeGRPB13StringBuilderE(self, show) {
  show.method_table.method_0(show.self, { self: self, method_table: _M0FP092moonbitlang_2fcore_2fbuiltin_2fStringBuilder_24as_24_40moonbitlang_2fcore_2fbuiltin_2eLogger });
}
function _M0MPC16string6String21clamped__view_2einner(self, start, end) {
  const len = self.length;
  let lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _e = _Some;
    hi = _e < 0 ? 0 : _e > len ? len : _e;
  }
  let _tmp;
  if (lo > 0) {
    let _tmp$2;
    if (lo < len) {
      let _tmp$3;
      const _p = self.charCodeAt(lo);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = self.charCodeAt(lo - 1 | 0);
        _tmp$3 = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp$3 = false;
      }
      _tmp$2 = _tmp$3;
    } else {
      _tmp$2 = false;
    }
    _tmp = _tmp$2;
  } else {
    _tmp = false;
  }
  if (_tmp) {
    lo = lo + 1 | 0;
  }
  let _tmp$2;
  if (hi > 0) {
    let _tmp$3;
    if (hi < len) {
      let _tmp$4;
      const _p = self.charCodeAt(hi);
      if (_p >= 56320 && _p <= 57343) {
        const _p$2 = self.charCodeAt(hi - 1 | 0);
        _tmp$4 = _p$2 >= 55296 && _p$2 <= 56319;
      } else {
        _tmp$4 = false;
      }
      _tmp$3 = _tmp$4;
    } else {
      _tmp$3 = false;
    }
    _tmp$2 = _tmp$3;
  } else {
    _tmp$2 = false;
  }
  if (_tmp$2) {
    hi = hi - 1 | 0;
  }
  return lo >= hi ? new _M0TPC16string10StringView(self, lo, lo) : new _M0TPC16string10StringView(self, lo, hi);
}
function _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(self, value, start, len) {
  _M0IPB13StringBuilderPB6Logger11write__view(self, _M0MPC16string6String21clamped__view_2einner(value, start, start + len | 0));
}
function _M0IP016_24default__implPB4Show6outputGsE(self, logger) {
  logger.method_table.method_0(logger.self, self);
}
function _M0IP016_24default__implPB4Show6outputGiE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC13int3IntPB4Show10to__string(self));
}
function _M0IP016_24default__implPB4Show6outputGdE(self, logger) {
  logger.method_table.method_0(logger.self, _M0IPC16double6DoublePB4Show10to__string(self));
}
function _M0MPB4Iter4nextGUsRPB4JsonEE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === undefined) {
    self.size_hint = _M0MPB4Iter4nextN6constrS9910GUsRPB4JsonEE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS9909GUsRPB4JsonEE;
    }
  }
  return result;
}
function _M0MPB4Iter4nextGcE(self) {
  const _func = self.f;
  const result = _func();
  const _bind = self.size_hint;
  if (result === -1) {
    self.size_hint = _M0MPB4Iter4nextN6constrS9910GcE;
  } else {
    if (_bind === undefined) {
    } else {
      const _Some = _bind;
      const _n = _Some;
      self.size_hint = _n > 0 ? _n - 1 | 0 : _M0MPB4Iter4nextN6constrS9909GcE;
    }
  }
  return result;
}
function _M0MPC13int3Int18to__string_2einner(self, radix) {
  return _M0FPB19int__to__string__js(self, radix);
}
function _M0MPB4Iter3newGUsRPB4JsonEE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS9917GUsRPB4JsonEE;
  }
  return new _M0TPB4IterGUsRPB4JsonEE(f, size_hint$2);
}
function _M0MPB4Iter3newGcE(f, size_hint) {
  let size_hint$2;
  if (size_hint === undefined) {
    size_hint$2 = undefined;
  } else {
    const _Some = size_hint;
    const _n = _Some;
    size_hint$2 = _n > 0 ? _n : _M0MPB4Iter3newN6constrS9917GcE;
  }
  return new _M0TPB4IterGcE(f, size_hint$2);
}
function _M0MPC16string10StringView9to__owned(self) {
  return self.str.substring(self.start, self.end);
}
function _M0MPC16string10StringView4iter(self) {
  const start = self.start;
  const end = self.end;
  const index = new _M0TPB8MutLocalGiE(start);
  return _M0MPB4Iter3newGcE(() => {
    if (index.val < end) {
      const c1 = self.str.charCodeAt(index.val);
      if (c1 >= 55296 && c1 <= 56319 && (index.val + 1 | 0) < self.end) {
        const c2 = self.str.charCodeAt(index.val + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          index.val = index.val + 2 | 0;
          return _M0FPB32code__point__of__surrogate__pair(c1, c2);
        }
      }
      index.val = index.val + 1 | 0;
      return c1;
    } else {
      return -1;
    }
  }, undefined);
}
function _M0MPC16string6String20unsafe__range__equal(self, self_off, other, other_off, len) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < len) {
      const _p = self.charCodeAt(self_off + i | 0);
      const _p$2 = other.charCodeAt(other_off + i | 0);
      if (_p === _p$2) {
      } else {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0MPC16string6String11from__array(chars) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(Math.imul(chars.end - chars.start | 0, 4) | 0);
  const _bind = chars.end - chars.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const c = chars.buf[chars.start + _ | 0];
      _M0IPB13StringBuilderPB6Logger11write__char(buf, c);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return buf.val;
}
function _M0MPC16string6String31offset__of__nth__char__backward(self, n, start_offset, end_offset) {
  let _tmp = end_offset;
  let _tmp$2 = 0;
  while (true) {
    const utf16_offset = _tmp;
    const char_count = _tmp$2;
    if ((utf16_offset - 1 | 0) >= start_offset && char_count < n) {
      const c = self.charCodeAt(utf16_offset - 1 | 0);
      if (c >= 56320 && c <= 57343) {
        _tmp = utf16_offset - 2 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      } else {
        _tmp = utf16_offset - 1 | 0;
        _tmp$2 = char_count + 1 | 0;
        continue;
      }
    } else {
      return char_count < n || utf16_offset < start_offset ? undefined : utf16_offset;
    }
  }
}
function _M0MPC16string6String30offset__of__nth__char__forward(self, n, start_offset, end_offset) {
  if (start_offset >= 0 && start_offset <= end_offset) {
    let _tmp = start_offset;
    let _tmp$2 = 0;
    while (true) {
      const utf16_offset = _tmp;
      const char_count = _tmp$2;
      if (utf16_offset < end_offset && char_count < n) {
        const c = self.charCodeAt(utf16_offset);
        if (c >= 55296 && c <= 56319) {
          _tmp = utf16_offset + 2 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        } else {
          _tmp = utf16_offset + 1 | 0;
          _tmp$2 = char_count + 1 | 0;
          continue;
        }
      } else {
        return char_count < n || utf16_offset >= end_offset ? undefined : utf16_offset;
      }
    }
  } else {
    return $panic();
  }
}
function _M0MPC16string6String29offset__of__nth__char_2einner(self, i, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  return i >= 0 ? _M0MPC16string6String30offset__of__nth__char__forward(self, i, start_offset, end_offset$2) : _M0MPC16string6String31offset__of__nth__char__backward(self, -i | 0, start_offset, end_offset$2);
}
function _M0MPC16string6String12view_2einner(self, start_offset, end_offset) {
  let end_offset$2;
  if (end_offset === undefined) {
    end_offset$2 = self.length;
  } else {
    const _Some = end_offset;
    end_offset$2 = _Some;
  }
  if (start_offset >= 0 && (start_offset <= end_offset$2 && end_offset$2 <= self.length)) {
    return new _M0TPC16string10StringView(self, start_offset, end_offset$2);
  } else {
    return $panic();
  }
}
function _M0IPB13StringBuilderPB6Logger11write__view(self, str) {
  self.val = `${self.val}${_M0MPC16string10StringView9to__owned(str)}`;
}
function _M0FPB19kmp__failure__table(pattern) {
  const m = pattern.end - pattern.start | 0;
  const table = $make_array_len_and_init(m, 0);
  let k = 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < m) {
      const c = pattern.str.charCodeAt(pattern.start + i | 0);
      while (true) {
        let _tmp$2;
        if (k > 0) {
          const _p = pattern.str.charCodeAt(pattern.start + k | 0);
          _tmp$2 = c !== _p;
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          const _tmp$3 = k - 1 | 0;
          k = _tmp$3 >>> 0 < table.length ? table[_tmp$3] : $oob();
          continue;
        } else {
          break;
        }
      }
      const _p = pattern.str.charCodeAt(pattern.start + k | 0);
      if (c === _p) {
        k = k + 1 | 0;
      }
      if (i >>> 0 < table.length) {
        table[i] = k;
      } else {
        $oob();
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return table;
}
function _M0FPB24find__pattern__kmp__from(target, pattern, start) {
  const n = target.end - target.start | 0;
  const m = pattern.end - pattern.start | 0;
  const table = _M0FPB19kmp__failure__table(pattern);
  let k = 0;
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < n) {
      const c = target.str.charCodeAt(target.start + i | 0);
      while (true) {
        let _tmp$2;
        if (k > 0) {
          const _p = pattern.str.charCodeAt(pattern.start + k | 0);
          _tmp$2 = c !== _p;
        } else {
          _tmp$2 = false;
        }
        if (_tmp$2) {
          const _tmp$3 = k - 1 | 0;
          k = _tmp$3 >>> 0 < table.length ? table[_tmp$3] : $oob();
          continue;
        } else {
          break;
        }
      }
      const _p = pattern.str.charCodeAt(pattern.start + k | 0);
      if (c === _p) {
        k = k + 1 | 0;
      }
      if (k === m) {
        return (i - m | 0) + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < candidate_end) {
      let _tmp$2;
      const _p = data.charCodeAt(pos);
      if (_p === first) {
        const _p$2 = data.charCodeAt(pos + last_offset | 0);
        _tmp$2 = _p$2 === last;
      } else {
        _tmp$2 = false;
      }
      if (_tmp$2) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB42find__two__anchor__candidate__from__string(data, start, candidate_end, first, last_offset, last) {
  return _M0FPB36find__two__anchor__candidate__scalar(data, start, candidate_end, first, last_offset, last);
}
function _M0FPB21string__ranges__equal(left, left_start, right, right_start, length) {
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < length) {
      const _p = left.charCodeAt(left_start + i | 0);
      const _p$2 = right.charCodeAt(right_start + i | 0);
      if (_p !== _p$2) {
        return false;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return true;
}
function _M0FPB22find__by__two__anchors(target, pattern) {
  const target_len = target.end - target.start | 0;
  const pattern_len = pattern.end - pattern.start | 0;
  const target_start = target.start;
  const pattern_start = pattern.start;
  const last_offset = pattern_len - 1 | 0;
  const candidate_end = ((target_start + target_len | 0) - pattern_len | 0) + 1 | 0;
  const first = pattern.str.charCodeAt(pattern.start);
  const last = pattern.str.charCodeAt(pattern.start + last_offset | 0);
  const middle_len = last_offset - 1 | 0;
  let _tmp = target_start;
  let _tmp$2 = 0;
  while (true) {
    const pos = _tmp;
    const failures = _tmp$2;
    if (pos < candidate_end) {
      const found = _M0FPB42find__two__anchor__candidate__from__string(target.str, pos, candidate_end, first, last_offset, last);
      if (found < 0) {
        return undefined;
      }
      if (_M0FPB21string__ranges__equal(target.str, found + 1 | 0, pattern.str, pattern_start + 1 | 0, middle_len)) {
        return found - target_start | 0;
      }
      const failures$2 = failures + 1 | 0;
      const scanned = found - target_start | 0;
      if (failures$2 > 64 || failures$2 > (4 + (scanned / 8 | 0) | 0)) {
        return _M0FPB24find__pattern__kmp__from(target, pattern, scanned + 1 | 0);
      }
      _tmp = found + 1 | 0;
      _tmp$2 = failures$2;
      continue;
    } else {
      return undefined;
    }
  }
}
function _M0FPB24find__code__unit__scalar(data, start, end, code) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    if (pos < end) {
      const _p = data.charCodeAt(pos);
      if (_p === code) {
        return pos;
      }
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return -1;
    }
  }
}
function _M0FPB30find__code__unit__from__string(data, start, end, code) {
  return _M0FPB24find__code__unit__scalar(data, start, end, code);
}
function _M0FPB28find__code__unit__from__view(target, start, end, code) {
  const target_start = target.start;
  const found = _M0FPB30find__code__unit__from__string(target.str, target_start + start | 0, target_start + end | 0, code);
  return found < 0 ? -1 : found - target_start | 0;
}
function _M0MPC16string10StringView4find(self, str) {
  const pattern_len = str.end - str.start | 0;
  switch (pattern_len) {
    case 0: {
      return _M0MPC16string10StringView4findN6constrS9919;
    }
    case 1: {
      const found = _M0FPB28find__code__unit__from__view(self, 0, self.end - self.start | 0, str.str.charCodeAt(str.start));
      return found < 0 ? undefined : found;
    }
    default: {
      return pattern_len > (self.end - self.start | 0) ? undefined : _M0FPB22find__by__two__anchors(self, str);
    }
  }
}
function _M0MPC16string6String4find(self, str) {
  return _M0MPC16string10StringView4find(new _M0TPC16string10StringView(self, 0, self.length), str);
}
function _M0MPC16string6String6repeat(self, n) {
  if (n < 0) {
    return $panic();
  } else {
    if (n === 0) {
      return "";
    } else {
      if (n === 1) {
        return self;
      } else {
        const len = self.length;
        const total = Math.imul(len, n) | 0;
        if (len === 0 || (total / n | 0) === len) {
          const buf = _M0MPB13StringBuilder21StringBuilder_2einner(total);
          const str = self;
          let _tmp = 0;
          while (true) {
            const _ = _tmp;
            if (_ < n) {
              _M0IPB13StringBuilderPB6Logger13write__string(buf, str);
              _tmp = _ + 1 | 0;
              continue;
            } else {
              break;
            }
          }
          return buf.val;
        } else {
          return $panic();
        }
      }
    }
  }
}
function _M0MPC16string6String8find__by(self, pred) {
  const _p = new _M0TPC16string10StringView(self, 0, self.length);
  const _p$2 = _p.str;
  const _p$3 = _p.start;
  const _p$4 = _p.end;
  let _tmp = _p$3;
  let _tmp$2 = 0;
  while (true) {
    const _p$5 = _tmp;
    const _p$6 = _tmp$2;
    if (_p$5 < _p$4) {
      let _p$7;
      let _p$8;
      _L: {
        const _p$9 = _p$2.charCodeAt(_p$5);
        if (_p$9 >= 55296 && _p$9 <= 56319 && (_p$5 + 1 | 0) < _p$4) {
          const _p$10 = _p$2.charCodeAt(_p$5 + 1 | 0);
          if (_p$10 >= 56320 && _p$10 <= 57343) {
            const _tmp$3 = _p$5 + 2 | 0;
            const _p$11 = (((Math.imul(_p$9 - 55296 | 0, 1024) | 0) + _p$10 | 0) - 56320 | 0) + 65536 | 0;
            _p$7 = _tmp$3;
            _p$8 = _p$11;
            break _L;
          } else {
            const _tmp$3 = _p$5 + 1 | 0;
            const _p$11 = _p$9;
            _p$7 = _tmp$3;
            _p$8 = _p$11;
            break _L;
          }
        } else {
          const _tmp$3 = _p$5 + 1 | 0;
          const _p$10 = _p$9;
          _p$7 = _tmp$3;
          _p$8 = _p$10;
          break _L;
        }
      }
      if (pred(_p$8)) {
        return _p$6;
      }
      _tmp = _p$7;
      const _p$9 = _p$8;
      _tmp$2 = _p$6 + (_p$9 <= 65535 ? 1 : 2) | 0;
      continue;
    } else {
      return undefined;
    }
  }
}
function _M0MPC16string10StringView11has__prefix(self, str) {
  const str_len = str.end - str.start | 0;
  if (str_len <= (self.end - self.start | 0)) {
    let _tmp;
    if (str_len === 0) {
      _tmp = true;
    } else {
      const _p = self.str.charCodeAt(self.start);
      const _p$2 = str.str.charCodeAt(str.start);
      _tmp = _p === _p$2;
    }
    if (_tmp) {
      return _M0MPC16string6String20unsafe__range__equal(self.str, self.start, str.str, str.start, str_len);
    } else {
      return false;
    }
  } else {
    return false;
  }
}
function _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGRPB5ArrayGRP26Ljh68411sqlsentinel5TokenEE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0MPC15array5Array4pushGcE(self, value) {
  _M0MPB7JSArray4push(self, value);
}
function _M0FPB36string__contains__code__unit__scalar(str, start, end, code) {
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      const _p = str.charCodeAt(i);
      if (_p === code) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FPB28string__contains__code__unit(str, start, end, code) {
  return _M0FPB36string__contains__code__unit__scalar(str, start, end, code);
}
function _M0MPC16string10StringView20contains__code__unit(self, code) {
  return _M0FPB28string__contains__code__unit(self.str, self.start, self.end, code);
}
function _M0FPB23build__ascii__char__set(chars) {
  let bits0 = 0;
  let bits1 = 0;
  let bits2 = 0;
  let bits3 = 0;
  const _bind = chars.str;
  const _bind$2 = chars.start;
  const _bind$3 = chars.end;
  let _tmp = _bind$2;
  while (true) {
    const _string_index = _tmp;
    if (_string_index < _bind$3) {
      let _decoded_next_string_index;
      let _decoded_char;
      _L: {
        const _bind$4 = _bind.charCodeAt(_string_index);
        if (_bind$4 >= 55296 && _bind$4 <= 56319 && (_string_index + 1 | 0) < _bind$3) {
          const _bind$5 = _bind.charCodeAt(_string_index + 1 | 0);
          if (_bind$5 >= 56320 && _bind$5 <= 57343) {
            const _tmp$2 = _string_index + 2 | 0;
            const _p = (((Math.imul(_bind$4 - 55296 | 0, 1024) | 0) + _bind$5 | 0) - 56320 | 0) + 65536 | 0;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$4;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        } else {
          const _tmp$2 = _string_index + 1 | 0;
          const _p = _bind$4;
          _decoded_next_string_index = _tmp$2;
          _decoded_char = _p;
          break _L;
        }
      }
      const code = _decoded_char;
      if (code >>> 0 < 128 >>> 0) {
        const bit = 1 << (code & 31);
        const _bind$4 = code >>> 5 | 0;
        switch (_bind$4) {
          case 0: {
            bits0 = bits0 | bit;
            break;
          }
          case 1: {
            bits1 = bits1 | bit;
            break;
          }
          case 2: {
            bits2 = bits2 | bit;
            break;
          }
          default: {
            bits3 = bits3 | bit;
          }
        }
      } else {
        return undefined;
      }
      _tmp = _decoded_next_string_index;
      continue;
    } else {
      break;
    }
  }
  return { _0: bits0, _1: bits1, _2: bits2, _3: bits3 };
}
function _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, code) {
  if (code >>> 0 < 128 >>> 0) {
    const bit = 1 << (code & 31);
    const _bind = code >>> 5 | 0;
    switch (_bind) {
      case 0: {
        return (bits0 & bit) !== 0;
      }
      case 1: {
        return (bits1 & bit) !== 0;
      }
      case 2: {
        return (bits2 & bit) !== 0;
      }
      default: {
        return (bits3 & bit) !== 0;
      }
    }
  } else {
    return false;
  }
}
function _M0FPB34string__trim__start__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3) {
  let _tmp = start;
  while (true) {
    const pos = _tmp;
    let _tmp$2;
    if (pos < end) {
      const _p = str.charCodeAt(pos);
      _tmp$2 = _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, _p);
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      _tmp = pos + 1 | 0;
      continue;
    } else {
      return pos;
    }
  }
}
function _M0FPB32string__trim__end__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3) {
  let _tmp = end;
  while (true) {
    const pos = _tmp;
    let _tmp$2;
    if (pos > start) {
      const _p = str.charCodeAt(pos - 1 | 0);
      _tmp$2 = _M0FPB26ascii__char__set__contains(bits0, bits1, bits2, bits3, _p);
    } else {
      _tmp$2 = false;
    }
    if (_tmp$2) {
      _tmp = pos - 1 | 0;
      continue;
    } else {
      return pos;
    }
  }
}
function _M0FPB26string__trim__start__ascii(str, start, end, _chars, bits0, bits1, bits2, bits3) {
  return _M0FPB34string__trim__start__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3);
}
function _M0FPB24string__trim__end__ascii(str, start, end, _chars, bits0, bits1, bits2, bits3) {
  return _M0FPB32string__trim__end__ascii__scalar(str, start, end, bits0, bits1, bits2, bits3);
}
function _M0MPC16string10StringView14contains__char(self, c) {
  const len = self.end - self.start | 0;
  if (len > 0) {
    const c$2 = c;
    if (c$2 >= 0 && c$2 <= 65535) {
      return _M0MPC16string10StringView20contains__code__unit(self, c$2 & 65535);
    } else {
      if (c$2 < 0) {
        return false;
      } else {
        if (len >= 2) {
          const adj = c$2 - 65536 | 0;
          const high = 55296 + (adj >> 10) | 0;
          if (high <= 65535) {
            const high$2 = high & 65535;
            const low = (56320 + (adj & 1023) | 0) & 65535;
            let _tmp = 0;
            while (true) {
              const i = _tmp;
              if (i < (len - 1 | 0)) {
                const _p = self.str.charCodeAt(self.start + i | 0);
                if (_p === high$2) {
                  const _p$2 = self.str.charCodeAt(self.start + (i + 1 | 0) | 0);
                  if (_p$2 === low) {
                    return true;
                  }
                  _tmp = i + 2 | 0;
                  continue;
                }
                _tmp = i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    }
    return false;
  } else {
    return false;
  }
}
function _M0MPC16string10StringView24trim__start__with__chars(self, chars) {
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if ((x.end - x.start | 0) === 0) {
      return x;
    } else {
      const _c = _M0MPC16string6String16unsafe__char__at(x.str, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, 0, x.start, x.end));
      const _tmp$2 = x.str;
      const _bind = _M0MPC16string6String29offset__of__nth__char_2einner(x.str, 1, x.start, x.end);
      let _tmp$3;
      if (_bind === undefined) {
        _tmp$3 = x.end;
      } else {
        const _Some = _bind;
        _tmp$3 = _Some;
      }
      const _x = new _M0TPC16string10StringView(_tmp$2, _tmp$3, x.end);
      if (_M0MPC16string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return x;
      }
    }
  }
}
function _M0MPC16string10StringView22trim__end__with__chars(self, chars) {
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if ((x.end - x.start | 0) === 0) {
      return x;
    } else {
      const _c = _M0MPC16string6String16unsafe__char__at(x.str, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, -1, x.start, x.end));
      const _x = new _M0TPC16string10StringView(x.str, x.start, _M0MPC16string6String29offset__of__nth__char_2einner(x.str, -1, x.start, x.end));
      if (_M0MPC16string10StringView14contains__char(chars, _c)) {
        _tmp = _x;
        continue;
      } else {
        return x;
      }
    }
  }
}
function _M0MPC16string10StringView12trim_2einner(self, chars) {
  const _bind = _M0FPB23build__ascii__char__set(chars);
  if (_bind === undefined) {
    return _M0MPC16string10StringView22trim__end__with__chars(_M0MPC16string10StringView24trim__start__with__chars(self, chars), chars);
  } else {
    const _Some = _bind;
    const _x = _Some;
    const _bits0 = _x._0;
    const _bits1 = _x._1;
    const _bits2 = _x._2;
    const _bits3 = _x._3;
    const start = _M0FPB26string__trim__start__ascii(self.str, self.start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    const end = _M0FPB24string__trim__end__ascii(self.str, start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    return new _M0TPC16string10StringView(self.str, start, end);
  }
}
function _M0MPC16string10StringView4trim(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = new _M0TPC16string10StringView(_M0MPC16string10StringView4trimN7_2abindS6831, 0, _M0MPC16string10StringView4trimN7_2abindS6831.length);
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MPC16string10StringView12trim_2einner(self, chars);
}
function _M0MPC16string10StringView19trim__start_2einner(self, chars) {
  const _bind = _M0FPB23build__ascii__char__set(chars);
  if (_bind === undefined) {
    return _M0MPC16string10StringView24trim__start__with__chars(self, chars);
  } else {
    const _Some = _bind;
    const _x = _Some;
    const _bits0 = _x._0;
    const _bits1 = _x._1;
    const _bits2 = _x._2;
    const _bits3 = _x._3;
    const start = _M0FPB26string__trim__start__ascii(self.str, self.start, self.end, chars, _bits0, _bits1, _bits2, _bits3);
    return new _M0TPC16string10StringView(self.str, start, self.end);
  }
}
function _M0MPC16string6String19trim__start_2einner(self, chars) {
  return _M0MPC16string10StringView19trim__start_2einner(new _M0TPC16string10StringView(self, 0, self.length), chars);
}
function _M0MPC16string6String11trim__start(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = new _M0TPC16string10StringView(_M0MPC16string6String11trim__startN7_2abindS6882, 0, _M0MPC16string6String11trim__startN7_2abindS6882.length);
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MPC16string6String19trim__start_2einner(self, chars);
}
function _M0MPC16string6String12trim_2einner(self, chars) {
  return _M0MPC16string10StringView12trim_2einner(new _M0TPC16string10StringView(self, 0, self.length), chars);
}
function _M0MPC16string6String4trim(self, chars$46$opt) {
  let chars;
  if (chars$46$opt === undefined) {
    chars = new _M0TPC16string10StringView(_M0MPC16string6String4trimN7_2abindS6932, 0, _M0MPC16string6String4trimN7_2abindS6932.length);
  } else {
    const _Some = chars$46$opt;
    chars = _Some;
  }
  return _M0MPC16string6String12trim_2einner(self, chars);
}
function _M0MPC16string6String4iter(self) {
  const len = self.length;
  const index = new _M0TPB8MutLocalGiE(0);
  return _M0MPB4Iter3newGcE(() => {
    if (index.val < len) {
      const c1 = self.charCodeAt(index.val);
      if (c1 >= 55296 && c1 <= 56319 && (index.val + 1 | 0) < len) {
        const c2 = self.charCodeAt(index.val + 1 | 0);
        if (c2 >= 56320 && c2 <= 57343) {
          const c = _M0FPB32code__point__of__surrogate__pair(c1, c2);
          index.val = index.val + 2 | 0;
          return c;
        }
      }
      index.val = index.val + 1 | 0;
      return c1;
    } else {
      return -1;
    }
  }, undefined);
}
function _M0MPB4Iter3mapGcRPC16string10StringViewE(self, f) {
  return new _M0TPB4IterGRPC16string10StringViewE(() => {
    const _bind = _M0MPB4Iter4nextGcE(self);
    if (_bind === -1) {
      return undefined;
    } else {
      const _Some = _bind;
      const _x = _Some;
      return f(_x);
    }
  }, self.size_hint);
}
function _M0IPC14char4CharPB4Show10to__string(self) {
  return String.fromCodePoint(self);
}
function _M0MPC16string10StringView5split(self, sep) {
  const sep_len = sep.end - sep.start | 0;
  if (sep_len === 0) {
    return _M0MPB4Iter3mapGcRPC16string10StringViewE(_M0MPC16string10StringView4iter(self), (c) => _M0MPC16string6String12view_2einner(_M0IPC14char4CharPB4Show10to__string(c), 0, undefined));
  }
  const remaining = new _M0TPB8MutLocalGORPC16string10StringViewE(self);
  return _M0MPB4Iter3newGUsRPB4JsonEE(() => {
    const _bind = remaining.val;
    if (_bind === undefined) {
      return undefined;
    } else {
      const _Some = _bind;
      const _view = _Some;
      const _bind$2 = _M0MPC16string10StringView4find(_view, sep);
      if (_bind$2 === undefined) {
        remaining.val = undefined;
        return _view;
      } else {
        const _Some$2 = _bind$2;
        const _end = _Some$2;
        remaining.val = _M0MPC16string10StringView12view_2einner(_view, _end + sep_len | 0, undefined);
        return _M0MPC16string10StringView12view_2einner(_view, 0, _end);
      }
    }
  }, undefined);
}
function _M0MPC16string6String5split(self, sep) {
  return _M0MPC16string10StringView5split(new _M0TPC16string10StringView(self, 0, self.length), sep);
}
function _M0MPC16string10StringView11split__once(self, needle) {
  const _bind = _M0MPC16string10StringView4find(self, needle);
  if (_bind === undefined) {
    return undefined;
  } else {
    const _Some = _bind;
    const _index = _Some;
    return { _0: _M0MPC16string10StringView12view_2einner(self, 0, _index), _1: _M0MPC16string10StringView12view_2einner(self, _index + (needle.end - needle.start | 0) | 0, undefined) };
  }
}
function _M0MPC16string6String11split__once(self, needle) {
  return _M0MPC16string10StringView11split__once(new _M0TPC16string10StringView(self, 0, self.length), needle);
}
function _M0MPC16string6String12replace__all(self, old, new_) {
  const len = self.length;
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(len);
  const old_len = old.end - old.start | 0;
  const new$2 = _M0MPC16string10StringView9to__owned(new_);
  if (old_len === 0) {
    _M0IPB13StringBuilderPB6Logger13write__string(buf, new$2);
    const _bind = self.length;
    let _tmp = 0;
    while (true) {
      const _string_index = _tmp;
      if (_string_index < _bind) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$2 = self.charCodeAt(_string_index);
          if (_bind$2 >= 55296 && _bind$2 <= 56319 && (_string_index + 1 | 0) < _bind) {
            const _bind$3 = self.charCodeAt(_string_index + 1 | 0);
            if (_bind$3 >= 56320 && _bind$3 <= 57343) {
              const _tmp$2 = _string_index + 2 | 0;
              const _p = (((Math.imul(_bind$2 - 55296 | 0, 1024) | 0) + _bind$3 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            } else {
              const _tmp$2 = _string_index + 1 | 0;
              const _p = _bind$2;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            }
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$2;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        }
        _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        _M0IPB13StringBuilderPB6Logger13write__string(buf, new$2);
        _tmp = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    return buf.val;
  } else {
    const first_end = _M0MPC16string6String4find(self, old);
    if (first_end === undefined) {
      return self;
    } else {
      const _Some = first_end;
      const _end = _Some;
      let _tmp = new _M0TPC16string10StringView(self, 0, self.length);
      let _tmp$2 = _end;
      while (true) {
        const view = _tmp;
        const end = _tmp$2;
        const seg = _M0MPC16string10StringView12view_2einner(view, 0, end);
        _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, seg.str, seg.start, seg.end - seg.start | 0);
        _M0IPB13StringBuilderPB6Logger13write__string(buf, new$2);
        if ((end + old_len | 0) <= len) {
          const next_view = _M0MPC16string10StringView12view_2einner(view, end + old_len | 0, undefined);
          const _bind = _M0MPC16string10StringView4find(next_view, old);
          if (_bind === undefined) {
            _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, next_view.str, next_view.start, next_view.end - next_view.start | 0);
            break;
          } else {
            const _Some$2 = _bind;
            const _next_end = _Some$2;
            _tmp = next_view;
            _tmp$2 = _next_end;
            continue;
          }
        } else {
          break;
        }
      }
      return buf.val;
    }
  }
}
function _M0MPC14char4Char20is__ascii__uppercase(self) {
  return self >= 65 && self <= 90;
}
function _M0MPC16string10StringView9to__lower(self) {
  const _p = self.str;
  const _p$2 = self.start;
  const _p$3 = self.end;
  let _bind;
  let _tmp = _p$2;
  let _tmp$2 = 0;
  while (true) {
    const _p$4 = _tmp;
    const _p$5 = _tmp$2;
    if (_p$4 < _p$3) {
      let _p$6;
      let _p$7;
      _L: {
        const _p$8 = _p.charCodeAt(_p$4);
        if (_p$8 >= 55296 && _p$8 <= 56319 && (_p$4 + 1 | 0) < _p$3) {
          const _p$9 = _p.charCodeAt(_p$4 + 1 | 0);
          if (_p$9 >= 56320 && _p$9 <= 57343) {
            const _tmp$3 = _p$4 + 2 | 0;
            const _p$10 = (((Math.imul(_p$8 - 55296 | 0, 1024) | 0) + _p$9 | 0) - 56320 | 0) + 65536 | 0;
            _p$6 = _tmp$3;
            _p$7 = _p$10;
            break _L;
          } else {
            const _tmp$3 = _p$4 + 1 | 0;
            const _p$10 = _p$8;
            _p$6 = _tmp$3;
            _p$7 = _p$10;
            break _L;
          }
        } else {
          const _tmp$3 = _p$4 + 1 | 0;
          const _p$9 = _p$8;
          _p$6 = _tmp$3;
          _p$7 = _p$9;
          break _L;
        }
      }
      if (_M0MPC14char4Char20is__ascii__uppercase(_p$7)) {
        _bind = _p$5;
        break;
      }
      _tmp = _p$6;
      const _p$8 = _p$7;
      _tmp$2 = _p$5 + (_p$8 <= 65535 ? 1 : 2) | 0;
      continue;
    } else {
      _bind = undefined;
      break;
    }
  }
  if (_bind === undefined) {
    return self;
  } else {
    const _Some = _bind;
    const _idx = _Some;
    const buf = _M0MPB13StringBuilder21StringBuilder_2einner(self.end - self.start | 0);
    const head = _M0MPC16string10StringView12view_2einner(self, 0, _idx);
    _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, head.str, head.start, head.end - head.start | 0);
    const _bind$2 = _M0MPC16string10StringView12view_2einner(self, _idx, undefined);
    const _bind$3 = _bind$2.str;
    const _bind$4 = _bind$2.start;
    const _bind$5 = _bind$2.end;
    let _tmp$3 = _bind$4;
    while (true) {
      const _string_index = _tmp$3;
      if (_string_index < _bind$5) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$6 = _bind$3.charCodeAt(_string_index);
          if (_bind$6 >= 55296 && _bind$6 <= 56319 && (_string_index + 1 | 0) < _bind$5) {
            const _bind$7 = _bind$3.charCodeAt(_string_index + 1 | 0);
            if (_bind$7 >= 56320 && _bind$7 <= 57343) {
              const _tmp$4 = _string_index + 2 | 0;
              const _p$4 = (((Math.imul(_bind$6 - 55296 | 0, 1024) | 0) + _bind$7 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$4;
              _decoded_char = _p$4;
              break _L;
            } else {
              const _tmp$4 = _string_index + 1 | 0;
              const _p$4 = _bind$6;
              _decoded_next_string_index = _tmp$4;
              _decoded_char = _p$4;
              break _L;
            }
          } else {
            const _tmp$4 = _string_index + 1 | 0;
            const _p$4 = _bind$6;
            _decoded_next_string_index = _tmp$4;
            _decoded_char = _p$4;
            break _L;
          }
        }
        if (_M0MPC14char4Char20is__ascii__uppercase(_decoded_char)) {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char + 32 | 0);
        } else {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        }
        _tmp$3 = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    const _bind$6 = buf.val;
    return new _M0TPC16string10StringView(_bind$6, 0, _bind$6.length);
  }
}
function _M0MPC16string6String9to__lower(self) {
  const _bind = _M0MPC16string6String8find__by(self, (c) => _M0MPC14char4Char20is__ascii__uppercase(c));
  if (_bind === undefined) {
    return self;
  } else {
    const _Some = _bind;
    const _idx = _Some;
    const buf = _M0MPB13StringBuilder21StringBuilder_2einner(self.length);
    const head = _M0MPC16string6String12view_2einner(self, 0, _idx);
    _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, head.str, head.start, head.end - head.start | 0);
    const _bind$2 = _M0MPC16string6String12view_2einner(self, _idx, undefined);
    const _bind$3 = _bind$2.str;
    const _bind$4 = _bind$2.start;
    const _bind$5 = _bind$2.end;
    let _tmp = _bind$4;
    while (true) {
      const _string_index = _tmp;
      if (_string_index < _bind$5) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$6 = _bind$3.charCodeAt(_string_index);
          if (_bind$6 >= 55296 && _bind$6 <= 56319 && (_string_index + 1 | 0) < _bind$5) {
            const _bind$7 = _bind$3.charCodeAt(_string_index + 1 | 0);
            if (_bind$7 >= 56320 && _bind$7 <= 57343) {
              const _tmp$2 = _string_index + 2 | 0;
              const _p = (((Math.imul(_bind$6 - 55296 | 0, 1024) | 0) + _bind$7 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            } else {
              const _tmp$2 = _string_index + 1 | 0;
              const _p = _bind$6;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            }
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$6;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        }
        if (_M0MPC14char4Char20is__ascii__uppercase(_decoded_char)) {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char + 32 | 0);
        } else {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        }
        _tmp = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    return buf.val;
  }
}
function _M0MPC14char4Char20is__ascii__lowercase(self) {
  return self >= 97 && self <= 122;
}
function _M0MPC16string10StringView9to__upper(self) {
  const _p = self.str;
  const _p$2 = self.start;
  const _p$3 = self.end;
  let _bind;
  let _tmp = _p$2;
  let _tmp$2 = 0;
  while (true) {
    const _p$4 = _tmp;
    const _p$5 = _tmp$2;
    if (_p$4 < _p$3) {
      let _p$6;
      let _p$7;
      _L: {
        const _p$8 = _p.charCodeAt(_p$4);
        if (_p$8 >= 55296 && _p$8 <= 56319 && (_p$4 + 1 | 0) < _p$3) {
          const _p$9 = _p.charCodeAt(_p$4 + 1 | 0);
          if (_p$9 >= 56320 && _p$9 <= 57343) {
            const _tmp$3 = _p$4 + 2 | 0;
            const _p$10 = (((Math.imul(_p$8 - 55296 | 0, 1024) | 0) + _p$9 | 0) - 56320 | 0) + 65536 | 0;
            _p$6 = _tmp$3;
            _p$7 = _p$10;
            break _L;
          } else {
            const _tmp$3 = _p$4 + 1 | 0;
            const _p$10 = _p$8;
            _p$6 = _tmp$3;
            _p$7 = _p$10;
            break _L;
          }
        } else {
          const _tmp$3 = _p$4 + 1 | 0;
          const _p$9 = _p$8;
          _p$6 = _tmp$3;
          _p$7 = _p$9;
          break _L;
        }
      }
      if (_M0MPC14char4Char20is__ascii__lowercase(_p$7)) {
        _bind = _p$5;
        break;
      }
      _tmp = _p$6;
      const _p$8 = _p$7;
      _tmp$2 = _p$5 + (_p$8 <= 65535 ? 1 : 2) | 0;
      continue;
    } else {
      _bind = undefined;
      break;
    }
  }
  if (_bind === undefined) {
    return self;
  } else {
    const _Some = _bind;
    const _idx = _Some;
    const buf = _M0MPB13StringBuilder21StringBuilder_2einner(self.end - self.start | 0);
    const head = _M0MPC16string10StringView12view_2einner(self, 0, _idx);
    _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, head.str, head.start, head.end - head.start | 0);
    const _bind$2 = _M0MPC16string10StringView12view_2einner(self, _idx, undefined);
    const _bind$3 = _bind$2.str;
    const _bind$4 = _bind$2.start;
    const _bind$5 = _bind$2.end;
    let _tmp$3 = _bind$4;
    while (true) {
      const _string_index = _tmp$3;
      if (_string_index < _bind$5) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$6 = _bind$3.charCodeAt(_string_index);
          if (_bind$6 >= 55296 && _bind$6 <= 56319 && (_string_index + 1 | 0) < _bind$5) {
            const _bind$7 = _bind$3.charCodeAt(_string_index + 1 | 0);
            if (_bind$7 >= 56320 && _bind$7 <= 57343) {
              const _tmp$4 = _string_index + 2 | 0;
              const _p$4 = (((Math.imul(_bind$6 - 55296 | 0, 1024) | 0) + _bind$7 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$4;
              _decoded_char = _p$4;
              break _L;
            } else {
              const _tmp$4 = _string_index + 1 | 0;
              const _p$4 = _bind$6;
              _decoded_next_string_index = _tmp$4;
              _decoded_char = _p$4;
              break _L;
            }
          } else {
            const _tmp$4 = _string_index + 1 | 0;
            const _p$4 = _bind$6;
            _decoded_next_string_index = _tmp$4;
            _decoded_char = _p$4;
            break _L;
          }
        }
        if (_M0MPC14char4Char20is__ascii__lowercase(_decoded_char)) {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char - 32 | 0);
        } else {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        }
        _tmp$3 = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    const _bind$6 = buf.val;
    return new _M0TPC16string10StringView(_bind$6, 0, _bind$6.length);
  }
}
function _M0MPC16string6String9to__upper(self) {
  const _bind = _M0MPC16string6String8find__by(self, (c) => _M0MPC14char4Char20is__ascii__lowercase(c));
  if (_bind === undefined) {
    return self;
  } else {
    const _Some = _bind;
    const _idx = _Some;
    const buf = _M0MPB13StringBuilder21StringBuilder_2einner(self.length);
    const head = _M0MPC16string6String12view_2einner(self, 0, _idx);
    _M0IP016_24default__implPB6Logger16write__substringGRPB13StringBuilderE(buf, head.str, head.start, head.end - head.start | 0);
    const _bind$2 = _M0MPC16string6String12view_2einner(self, _idx, undefined);
    const _bind$3 = _bind$2.str;
    const _bind$4 = _bind$2.start;
    const _bind$5 = _bind$2.end;
    let _tmp = _bind$4;
    while (true) {
      const _string_index = _tmp;
      if (_string_index < _bind$5) {
        let _decoded_next_string_index;
        let _decoded_char;
        _L: {
          const _bind$6 = _bind$3.charCodeAt(_string_index);
          if (_bind$6 >= 55296 && _bind$6 <= 56319 && (_string_index + 1 | 0) < _bind$5) {
            const _bind$7 = _bind$3.charCodeAt(_string_index + 1 | 0);
            if (_bind$7 >= 56320 && _bind$7 <= 57343) {
              const _tmp$2 = _string_index + 2 | 0;
              const _p = (((Math.imul(_bind$6 - 55296 | 0, 1024) | 0) + _bind$7 | 0) - 56320 | 0) + 65536 | 0;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            } else {
              const _tmp$2 = _string_index + 1 | 0;
              const _p = _bind$6;
              _decoded_next_string_index = _tmp$2;
              _decoded_char = _p;
              break _L;
            }
          } else {
            const _tmp$2 = _string_index + 1 | 0;
            const _p = _bind$6;
            _decoded_next_string_index = _tmp$2;
            _decoded_char = _p;
            break _L;
          }
        }
        if (_M0MPC14char4Char20is__ascii__lowercase(_decoded_char)) {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char - 32 | 0);
        } else {
          _M0IPB13StringBuilderPB6Logger11write__char(buf, _decoded_char);
        }
        _tmp = _decoded_next_string_index;
        continue;
      } else {
        break;
      }
    }
    return buf.val;
  }
}
function _M0IPC16string6StringPB7Compare7compare(self, other) {
  const len = self.length;
  const _bind = $compare_int(len, other.length);
  if (_bind === 0) {
    let _tmp = 0;
    while (true) {
      const i = _tmp;
      if (i < len) {
        const _p = self.charCodeAt(i);
        const _p$2 = other.charCodeAt(i);
        const order = $compare_int(_p, _p$2);
        if (order !== 0) {
          return order;
        }
        _tmp = i + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    return 0;
  } else {
    return _bind;
  }
}
function _M0MPC16string6String9to__array(self) {
  const _p = _M0MPC16string6String4iter(self);
  const _p$2 = [];
  let _p$3 = _p$2;
  while (true) {
    const _p$4 = _M0MPB4Iter4nextGcE(_p);
    if (_p$4 === -1) {
      break;
    } else {
      const _p$5 = _p$4;
      const _p$6 = _p$5;
      const _p$7 = _p$3;
      _M0MPC15array5Array4pushGcE(_p$7, _p$6);
      _p$3 = _p$7;
      continue;
    }
  }
  return _p$3;
}
function _M0IPC13int3IntPB4Show10to__string(self) {
  return _M0MPC13int3Int18to__string_2einner(self, 10);
}
function _M0MPC13int3Int20next__power__of__two(self) {
  if (self >= 0) {
    if (self <= 1) {
      return 1;
    }
    if (self > 1073741824) {
      return 1073741824;
    }
    return (2147483647 >> (Math.clz32(self - 1 | 0) - 1 | 0)) + 1 | 0;
  } else {
    return $panic();
  }
}
function _M0FPB8new__mapGsiE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGsiE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB8new__mapGsRPB4JsonE(capacity) {
  const capacity$2 = _M0MPC13int3Int20next__power__of__two(capacity);
  const _bind = capacity$2 - 1 | 0;
  const _bind$2 = (Math.imul(capacity$2, 13) | 0) / 16 | 0;
  const _bind$3 = $make_array_len_and_init(capacity$2, undefined);
  const _bind$4 = undefined;
  return new _M0TPB3MapGsRPB4JsonE(_bind$3, 0, capacity$2, _bind, _bind$2, _bind$4, -1);
}
function _M0FPB21capacity__for__length(length) {
  let capacity = _M0MPC13int3Int20next__power__of__two(length);
  const _p = capacity;
  if (length > ((Math.imul(_p, 13) | 0) / 16 | 0)) {
    capacity = Math.imul(capacity, 2) | 0;
  }
  return capacity;
}
function _M0MPB3Map20add__entry__to__tailGsiE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, entry) {
  const _bind = self.tail;
  if (_bind === -1) {
    self.head = entry;
  } else {
    const _tmp = self.entries;
    const _p = _bind >>> 0 < _tmp.length ? _tmp[_bind] : $oob();
    let _tmp$2;
    if (_p === undefined) {
      _tmp$2 = $panic();
    } else {
      const _p$2 = _p;
      _tmp$2 = _p$2;
    }
    _tmp$2.next = entry;
  }
  self.tail = idx;
  self.entries[idx] = entry;
  self.size = self.size + 1 | 0;
}
function _M0MPB3Map10set__entryGsiE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10set__entryGsRPB4JsonE(self, entry, new_idx) {
  const _bind = entry.next;
  if (_bind === undefined) {
    self.tail = new_idx;
  } else {
    const _Some = _bind;
    const _next = _Some;
    _next.prev = new_idx;
  }
  self.entries[new_idx] = entry;
}
function _M0MPB3Map10push__awayGsiE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGsiE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGsiE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map10push__awayGsRPB4JsonE(self, idx, entry) {
  let _tmp = entry.psl + 1 | 0;
  let _tmp$2 = idx + 1 & self.capacity_mask;
  let _tmp$3 = entry;
  while (true) {
    const psl = _tmp;
    const idx$2 = _tmp$2;
    const entry$2 = _tmp$3;
    const _bind = self.entries[idx$2];
    if (_bind === undefined) {
      entry$2.psl = psl;
      _M0MPB3Map10set__entryGsRPB4JsonE(self, entry$2, idx$2);
      return;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (psl > _curr_entry.psl) {
        entry$2.psl = psl;
        _M0MPB3Map10set__entryGsRPB4JsonE(self, entry$2, idx$2);
        _tmp = _curr_entry.psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        _tmp$3 = _curr_entry;
        continue;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGsiE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGsiE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGsiE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGsiE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map20rehash__place__entryGsRPB4JsonE(self, outer) {
  const hash = outer.hash;
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      outer.psl = psl;
      outer.prev = self.tail;
      _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, outer);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr = _Some;
      if (psl > _curr.psl) {
        _M0MPB3Map10push__awayGsRPB4JsonE(self, idx, _curr);
        outer.psl = psl;
        outer.prev = self.tail;
        _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, outer);
        return undefined;
      } else {
        _tmp = psl + 1 | 0;
        _tmp$2 = idx + 1 & self.capacity_mask;
        continue;
      }
    }
  }
}
function _M0MPB3Map4growGsiE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGsiE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map4growGsRPB4JsonE(self) {
  const old_head = self.head;
  const new_capacity = self.capacity << 1;
  self.entries = $make_array_len_and_init(new_capacity, undefined);
  self.capacity = new_capacity;
  self.capacity_mask = new_capacity - 1 | 0;
  const _p = self.capacity;
  self.grow_at = (Math.imul(_p, 13) | 0) / 16 | 0;
  self.size = 0;
  self.head = undefined;
  self.tail = -1;
  let _tmp = old_head;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      return;
    } else {
      const _Some = x;
      const _e = _Some;
      const next_in_chain = _e.next;
      _e.next = undefined;
      _M0MPB3Map20rehash__place__entryGsRPB4JsonE(self, _e);
      _tmp = next_in_chain;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGsiE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGsiE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGsiE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGsiE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGsiE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGsiE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGsiE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGsiE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map15set__with__hashGsRPB4JsonE(self, key, value, hash) {
  let _tmp = 0;
  let _tmp$2 = hash & self.capacity_mask;
  while (true) {
    const psl = _tmp;
    const idx = _tmp$2;
    const _bind = self.entries[idx];
    if (_bind === undefined) {
      if (self.size >= self.grow_at) {
        _M0MPB3Map4growGsRPB4JsonE(self);
        _tmp = 0;
        _tmp$2 = hash & self.capacity_mask;
        continue;
      }
      const _bind$2 = self.tail;
      const _bind$3 = undefined;
      const entry = new _M0TPB5EntryGsRPB4JsonE(_bind$2, _bind$3, psl, hash, key, value);
      _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, entry);
      return undefined;
    } else {
      const _Some = _bind;
      const _curr_entry = _Some;
      if (_curr_entry.hash === hash && _curr_entry.key === key) {
        _curr_entry.value = value;
        return undefined;
      }
      if (psl > _curr_entry.psl) {
        if (self.size >= self.grow_at) {
          _M0MPB3Map4growGsRPB4JsonE(self);
          _tmp = 0;
          _tmp$2 = hash & self.capacity_mask;
          continue;
        }
        _M0MPB3Map10push__awayGsRPB4JsonE(self, idx, _curr_entry);
        const _bind$2 = self.tail;
        const _bind$3 = undefined;
        const entry = new _M0TPB5EntryGsRPB4JsonE(_bind$2, _bind$3, psl, hash, key, value);
        _M0MPB3Map20add__entry__to__tailGsRPB4JsonE(self, idx, entry);
        return undefined;
      }
      _tmp = psl + 1 | 0;
      _tmp$2 = idx + 1 & self.capacity_mask;
      continue;
    }
  }
}
function _M0MPB3Map3setGsiE(self, key, value) {
  _M0MPB3Map15set__with__hashGsiE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
}
function _M0MPB3Map3setGsRPB4JsonE(self, key, value) {
  _M0MPB3Map15set__with__hashGsRPB4JsonE(self, key, value, _M0IPC16string6StringPB4Hash4hash(key));
}
function _M0MPB3Map3MapGsiE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    const _p = _M0FPB21capacity__for__length(length);
    capacity$2 = _capacity > _p ? _capacity : _p;
  }
  const m = _M0FPB8new__mapGsiE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGsiE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map3MapGsRPB4JsonE(arr, capacity) {
  const length = arr.end - arr.start | 0;
  let capacity$2;
  if (capacity === undefined) {
    capacity$2 = length === 0 ? 8 : _M0FPB21capacity__for__length(length);
  } else {
    const _Some = capacity;
    const _capacity = _Some;
    const _p = _M0FPB21capacity__for__length(length);
    capacity$2 = _capacity > _p ? _capacity : _p;
  }
  const m = _M0FPB8new__mapGsRPB4JsonE(capacity$2);
  const _bind = arr.end - arr.start | 0;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const e = arr.buf[arr.start + _ | 0];
      _M0MPB3Map3setGsRPB4JsonE(m, e._0, e._1);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return m;
}
function _M0MPB3Map19update__or__defaultGsiE(self, key, default_, f) {
  const hash = _M0IPC16string6StringPB4Hash4hash(key);
  let idx;
  let psl;
  let push_away;
  _L: {
    let _tmp = 0;
    let _tmp$2 = hash & self.capacity_mask;
    while (true) {
      const psl$2 = _tmp;
      const idx$2 = _tmp$2;
      const _bind = self.entries[idx$2];
      if (_bind === undefined) {
        idx = idx$2;
        psl = psl$2;
        push_away = undefined;
        break _L;
      } else {
        const _Some = _bind;
        const _entry = _Some;
        if (_entry.hash === hash && _entry.key === key) {
          _entry.value = f(_entry.value);
          return undefined;
        }
        if (psl$2 > _entry.psl) {
          idx = idx$2;
          psl = psl$2;
          push_away = _entry;
          break _L;
        }
        _tmp = psl$2 + 1 | 0;
        _tmp$2 = idx$2 + 1 & self.capacity_mask;
        continue;
      }
    }
  }
  if (self.size >= self.grow_at) {
    _M0MPB3Map4growGsiE(self);
    _M0MPB3Map15set__with__hashGsiE(self, key, default_, hash);
    return;
  } else {
    if (push_away === undefined) {
    } else {
      const _Some = push_away;
      const _entry = _Some;
      _M0MPB3Map10push__awayGsiE(self, idx, _entry);
    }
    const entry = new _M0TPB5EntryGsiE(self.tail, undefined, psl, hash, key, default_);
    _M0MPB3Map20add__entry__to__tailGsiE(self, idx, entry);
    return;
  }
}
function _M0MPB3Map4iterGsRPB4JsonE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGsRPB4JsonEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUsRPB4JsonEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0MPB3Map4iterGsiE(self) {
  const curr_entry = new _M0TPB8MutLocalGORPB5EntryGsiEE(self.head);
  const len = self.size;
  const remaining = new _M0TPB8MutLocalGiE(len);
  return _M0MPB4Iter3newGUsRPB4JsonEE(() => {
    _L: {
      if (remaining.val > 0) {
        const _bind = curr_entry.val;
        if (_bind === undefined) {
          break _L;
        } else {
          const _Some = _bind;
          const _x = _Some;
          const _key = _x.key;
          const _value = _x.value;
          const _next = _x.next;
          curr_entry.val = _next;
          remaining.val = remaining.val - 1 | 0;
          return { _0: _key, _1: _value };
        }
      } else {
        break _L;
      }
    }
    return undefined;
  }, len);
}
function _M0MPB3Map5iter2GsiE(self) {
  return _M0MPB3Map4iterGsiE(self);
}
function _M0MPB5Iter24nextGsiE(self) {
  return _M0MPB4Iter4nextGUsRPB4JsonEE(self);
}
function _M0IPC16string6StringPB4Hash4hash(self) {
  let acc = (_M0FPB4seed >>> 0) + (374761393 >>> 0) | 0;
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      acc = (acc >>> 0) + (4 >>> 0) | 0;
      const v = self.charCodeAt(i);
      acc = _M0FPB13consume4__acc(acc, v);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return _M0FPB13finalize__acc(acc);
}
function _M0IPC16double6DoublePB4Show10to__string(self) {
  return String(self);
}
function _M0MPC14char4Char21is__ascii__alphabetic(self) {
  return self >= 65 && self <= 90 ? true : self >= 97 && self <= 122;
}
function _M0MPC14char4Char16is__ascii__digit(self) {
  return self >= 48 && self <= 57;
}
function _M0MPC14char4Char21is__ascii__whitespace(self) {
  return self >= 9 && self <= 13 ? true : self === 32;
}
function _M0MPC14char4Char14is__whitespace(self) {
  if (self <= 32) {
    return _M0MPC14char4Char21is__ascii__whitespace(self);
  }
  return self === 133 ? true : self === 160 ? true : self === 5760 ? true : self >= 8192 && self <= 8202 ? true : self === 8232 ? true : self === 8233 ? true : self === 8239 ? true : self === 8287 ? true : self === 12288;
}
function _M0MPC15array5Array21clamped__view_2einnerGcE(self, start, end) {
  const len = self.length;
  const lo = start < 0 ? 0 : start > len ? len : start;
  let hi;
  if (end === undefined) {
    hi = len;
  } else {
    const _Some = end;
    const _end = _Some;
    hi = _end < 0 ? 0 : _end > len ? len : _end;
  }
  const count = hi > lo ? hi - lo | 0 : 0;
  const _bind = self;
  return new _M0TPB9ArrayViewGcE(_bind, lo, lo + count | 0);
}
function _M0MPC15array5Array11unsafe__popGRPC14json10WriteFrameE(self) {
  return _M0MPB7JSArray3pop(self);
}
function _M0MPC15array5Array3popGRPC14json10WriteFrameE(self) {
  if (self.length === 0) {
    return undefined;
  } else {
    const v = _M0MPC15array5Array11unsafe__popGRPC14json10WriteFrameE(self);
    return v;
  }
}
function _M0MPC15array5Array2atGRPB4JsonE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGcE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array5Array2atGRPB5ArrayGRP26Ljh68411sqlsentinel5TokenEE(self, index) {
  const len = self.length;
  return index >= 0 && index < len ? self[index] : $panic();
}
function _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, i, j) {
  const temp = arr.buf[arr.start + i | 0];
  arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
  arr.buf[arr.start + j | 0] = temp;
}
function _M0MPC15array12MutArrayView5sliceGRP26Ljh68411sqlsentinel7FindingE(arr, start, end) {
  const _bind = arr.end - arr.start | 0;
  if (start < 0 || (start > end || end > _bind)) {
    $panic();
  }
  return new _M0TPB12MutArrayViewGRP26Ljh68411sqlsentinel7FindingE(arr.buf, start + arr.start | 0, end + arr.start | 0);
}
function _M0MPC15array12MutArrayView14rev__in__placeGRP26Ljh68411sqlsentinel7FindingE(arr) {
  const len = arr.end - arr.start | 0;
  const mid_len = len / 2 | 0;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < mid_len) {
      const j = (len - i | 0) - 1 | 0;
      const temp = arr.buf[arr.start + i | 0];
      arr.buf[arr.start + i | 0] = arr.buf[arr.start + j | 0];
      arr.buf[arr.start + j | 0] = temp;
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB17fixed__get__limit(len) {
  let _tmp = len;
  let _tmp$2 = 0;
  while (true) {
    const len$2 = _tmp;
    const limit = _tmp$2;
    if (len$2 > 0) {
      _tmp = len$2 / 2 | 0;
      _tmp$2 = limit + 1 | 0;
      continue;
    } else {
      return limit;
    }
  }
}
function _M0FPB23fixed__bubble__sort__byGRP26Ljh68411sqlsentinel7FindingE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      let _tmp$2 = i;
      while (true) {
        const j = _tmp$2;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, j, j - 1 | 0);
          _tmp$2 = j - 1 | 0;
          continue;
        } else {
          break;
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__2S444GRP26Ljh68411sqlsentinel7FindingE(_env, a, b) {
  const arr = _env._2;
  const cmp = _env._1;
  const swaps = _env._0;
  if (cmp(arr.buf[arr.start + a | 0], arr.buf[arr.start + b | 0]) > 0) {
    _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, a, b);
    swaps.val = swaps.val + 1 | 0;
    return;
  } else {
    return;
  }
}
function _M0FPB24fixed__choose__pivot__byN7sort__3S448GRP26Ljh68411sqlsentinel7FindingE(_env, a, b, c) {
  _M0FPB24fixed__choose__pivot__byN7sort__2S444GRP26Ljh68411sqlsentinel7FindingE(_env, a, b);
  _M0FPB24fixed__choose__pivot__byN7sort__2S444GRP26Ljh68411sqlsentinel7FindingE(_env, b, c);
  _M0FPB24fixed__choose__pivot__byN7sort__2S444GRP26Ljh68411sqlsentinel7FindingE(_env, a, b);
}
function _M0FPB24fixed__choose__pivot__byGRP26Ljh68411sqlsentinel7FindingE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const swaps = new _M0TPB8MutLocalGiE(0);
  const b = Math.imul(len / 4 | 0, 2) | 0;
  if (len >= 8) {
    const a = Math.imul(len / 4 | 0, 1) | 0;
    const c = Math.imul(len / 4 | 0, 3) | 0;
    const _env = { _0: swaps, _1: cmp, _2: arr };
    if (len > 50) {
      _M0FPB24fixed__choose__pivot__byN7sort__3S448GRP26Ljh68411sqlsentinel7FindingE(_env, a - 1 | 0, a, a + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S448GRP26Ljh68411sqlsentinel7FindingE(_env, b - 1 | 0, b, b + 1 | 0);
      _M0FPB24fixed__choose__pivot__byN7sort__3S448GRP26Ljh68411sqlsentinel7FindingE(_env, c - 1 | 0, c, c + 1 | 0);
    }
    _M0FPB24fixed__choose__pivot__byN7sort__3S448GRP26Ljh68411sqlsentinel7FindingE(_env, a, b, c);
  }
  if (swaps.val === 12) {
    _M0MPC15array12MutArrayView14rev__in__placeGRP26Ljh68411sqlsentinel7FindingE(arr);
    return { _0: (len - b | 0) - 1 | 0, _1: true };
  } else {
    return { _0: b, _1: swaps.val === 0 };
  }
}
function _M0FPB21fixed__sift__down__byGRP26Ljh68411sqlsentinel7FindingE(arr, index, cmp) {
  const len = arr.end - arr.start | 0;
  let _tmp = index;
  let _tmp$2 = (Math.imul(index, 2) | 0) + 1 | 0;
  while (true) {
    const index$2 = _tmp;
    const child = _tmp$2;
    if (child < len) {
      const child$2 = (child + 1 | 0) < len && cmp(arr.buf[arr.start + child | 0], arr.buf[arr.start + (child + 1 | 0) | 0]) < 0 ? child + 1 | 0 : child;
      if (cmp(arr.buf[arr.start + index$2 | 0], arr.buf[arr.start + child$2 | 0]) >= 0) {
        return undefined;
      }
      _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, index$2, child$2);
      _tmp = child$2;
      _tmp$2 = (Math.imul(child$2, 2) | 0) + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB21fixed__heap__sort__byGRP26Ljh68411sqlsentinel7FindingE(arr, cmp) {
  const len = arr.end - arr.start | 0;
  const _bind = len / 2 | 0;
  let _tmp = _bind - 1 | 0;
  while (true) {
    const i = _tmp;
    if (i >= 0) {
      _M0FPB21fixed__sift__down__byGRP26Ljh68411sqlsentinel7FindingE(arr, i, cmp);
      _tmp = i - 1 | 0;
      continue;
    } else {
      break;
    }
  }
  let _tmp$2 = len - 1 | 0;
  while (true) {
    const i = _tmp$2;
    if (i >= 1) {
      _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, 0, i);
      _M0FPB21fixed__sift__down__byGRP26Ljh68411sqlsentinel7FindingE(_M0MPC15array12MutArrayView5sliceGRP26Ljh68411sqlsentinel7FindingE(arr, 0, i), 0, cmp);
      _tmp$2 = i - 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPB20fixed__partition__byGRP26Ljh68411sqlsentinel7FindingE(arr, cmp, pivot_index) {
  _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, pivot_index, (arr.end - arr.start | 0) - 1 | 0);
  const pivot = arr.buf[arr.start + ((arr.end - arr.start | 0) - 1 | 0) | 0];
  const _bind = (arr.end - arr.start | 0) - 1 | 0;
  let _tmp = 0;
  let _tmp$2 = 0;
  let _tmp$3 = true;
  while (true) {
    const j = _tmp;
    const i = _tmp$2;
    const partitioned = _tmp$3;
    if (j < _bind) {
      if (cmp(arr.buf[arr.start + j | 0], pivot) < 0) {
        if (i !== j) {
          _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, i, j);
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          _tmp$3 = false;
          continue;
        } else {
          _tmp = j + 1 | 0;
          _tmp$2 = i + 1 | 0;
          continue;
        }
      } else {
        _tmp = j + 1 | 0;
        continue;
      }
    } else {
      _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, i, (arr.end - arr.start | 0) - 1 | 0);
      return { _0: i, _1: partitioned };
    }
  }
}
function _M0FPB28fixed__try__bubble__sort__byGRP26Ljh68411sqlsentinel7FindingE(arr, cmp) {
  const _bind = arr.end - arr.start | 0;
  let _tmp = 1;
  let _tmp$2 = 0;
  while (true) {
    const i = _tmp;
    const tries = _tmp$2;
    if (i < _bind) {
      let sorted;
      let _tmp$3 = i;
      let _tmp$4 = true;
      while (true) {
        const j = _tmp$3;
        const sorted$2 = _tmp$4;
        if (j > 0 && cmp(arr.buf[arr.start + (j - 1 | 0) | 0], arr.buf[arr.start + j | 0]) > 0) {
          _M0MPC15array12MutArrayView4swapGRP26Ljh68411sqlsentinel7FindingE(arr, j, j - 1 | 0);
          _tmp$3 = j - 1 | 0;
          _tmp$4 = false;
          continue;
        } else {
          sorted = sorted$2;
          break;
        }
      }
      if (!sorted) {
        const tries$2 = tries + 1 | 0;
        if (tries$2 > 8) {
          return false;
        }
        _tmp = i + 1 | 0;
        _tmp$2 = tries$2;
        continue;
      } else {
        _tmp = i + 1 | 0;
        continue;
      }
    } else {
      return true;
    }
  }
}
function _M0FPB22fixed__quick__sort__byGRP26Ljh68411sqlsentinel7FindingE(arr, cmp, pred, limit) {
  let _tmp = limit;
  let _tmp$2 = arr;
  let _tmp$3 = pred;
  let _tmp$4 = true;
  let _tmp$5 = true;
  while (true) {
    const limit$2 = _tmp;
    const arr$2 = _tmp$2;
    const pred$2 = _tmp$3;
    const was_partitioned = _tmp$4;
    const balanced = _tmp$5;
    const len = arr$2.end - arr$2.start | 0;
    if (len <= 16) {
      if (len >= 2) {
        _M0FPB23fixed__bubble__sort__byGRP26Ljh68411sqlsentinel7FindingE(arr$2, cmp);
      }
      return undefined;
    }
    if (limit$2 === 0) {
      _M0FPB21fixed__heap__sort__byGRP26Ljh68411sqlsentinel7FindingE(arr$2, cmp);
      return undefined;
    }
    const _bind = _M0FPB24fixed__choose__pivot__byGRP26Ljh68411sqlsentinel7FindingE(arr$2, cmp);
    const _pivot_index = _bind._0;
    const _likely_sorted = _bind._1;
    if (was_partitioned && (balanced && _likely_sorted)) {
      if (_M0FPB28fixed__try__bubble__sort__byGRP26Ljh68411sqlsentinel7FindingE(arr$2, cmp)) {
        return undefined;
      }
    }
    const _bind$2 = _M0FPB20fixed__partition__byGRP26Ljh68411sqlsentinel7FindingE(arr$2, cmp, _pivot_index);
    const _pivot = _bind$2._0;
    const _partitioned = _bind$2._1;
    const _p = len - _pivot | 0;
    const balanced$2 = (_pivot > _p ? _p : _pivot) >= (len / 8 | 0);
    const limit$3 = !balanced$2 ? limit$2 - 1 | 0 : limit$2;
    if (pred$2 === undefined) {
    } else {
      const _Some = pred$2;
      const _p$2 = _Some;
      if (cmp(_p$2, arr$2.buf[arr$2.start + _pivot | 0]) === 0) {
        let i;
        let _tmp$6 = _pivot;
        while (true) {
          const i$2 = _tmp$6;
          if (i$2 < len && cmp(_p$2, arr$2.buf[arr$2.start + i$2 | 0]) === 0) {
            _tmp$6 = i$2 + 1 | 0;
            continue;
          } else {
            i = i$2;
            break;
          }
        }
        _tmp = limit$3;
        _tmp$2 = _M0MPC15array12MutArrayView5sliceGRP26Ljh68411sqlsentinel7FindingE(arr$2, i, len);
        _tmp$4 = _partitioned;
        _tmp$5 = balanced$2;
        continue;
      }
    }
    const left = _M0MPC15array12MutArrayView5sliceGRP26Ljh68411sqlsentinel7FindingE(arr$2, 0, _pivot);
    const right = _M0MPC15array12MutArrayView5sliceGRP26Ljh68411sqlsentinel7FindingE(arr$2, _pivot + 1 | 0, len);
    if ((left.end - left.start | 0) < (right.end - right.start | 0)) {
      _M0FPB22fixed__quick__sort__byGRP26Ljh68411sqlsentinel7FindingE(left, cmp, pred$2, limit$3);
      _tmp = limit$3;
      _tmp$2 = right;
      _tmp$3 = arr$2.buf[arr$2.start + _pivot | 0];
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    } else {
      _M0FPB22fixed__quick__sort__byGRP26Ljh68411sqlsentinel7FindingE(right, cmp, arr$2.buf[arr$2.start + _pivot | 0], limit$3);
      _tmp = limit$3;
      _tmp$2 = left;
      _tmp$4 = _partitioned;
      _tmp$5 = balanced$2;
      continue;
    }
  }
}
function _M0MPC15array12MutArrayView8sort__byGRP26Ljh68411sqlsentinel7FindingE(self, cmp) {
  _M0FPB22fixed__quick__sort__byGRP26Ljh68411sqlsentinel7FindingE(self, cmp, undefined, _M0FPB17fixed__get__limit(self.end - self.start | 0));
}
function _M0MPC15array5Array8sort__byGRP26Ljh68411sqlsentinel7FindingE(self, cmp) {
  const _bind = self.length;
  _M0MPC15array12MutArrayView8sort__byGRP26Ljh68411sqlsentinel7FindingE(new _M0TPB12MutArrayViewGRP26Ljh68411sqlsentinel7FindingE(self, 0, _bind), cmp);
}
function _M0MPC15array5Array8containsGsE(self, value) {
  const _bind = self.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const v = self[_];
      if (v === value) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return false;
    }
  }
}
function _M0FPC14json20need__escape__scalar(str, escape_slash, start, end) {
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < end) {
      const code = str.charCodeAt(i);
      let _tmp$2;
      const _p = 34;
      if (code === _p) {
        _tmp$2 = true;
      } else {
        let _tmp$3;
        const _p$2 = 92;
        if (code === _p$2) {
          _tmp$3 = true;
        } else {
          let _tmp$4;
          if (code < 32) {
            _tmp$4 = true;
          } else {
            let _tmp$5;
            if (escape_slash) {
              const _p$3 = 47;
              _tmp$5 = code === _p$3;
            } else {
              _tmp$5 = false;
            }
            _tmp$4 = _tmp$5;
          }
          _tmp$3 = _tmp$4;
        }
        _tmp$2 = _tmp$3;
      }
      if (_tmp$2) {
        return true;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FPC14json12need__escape(str, escape_slash) {
  return _M0FPC14json20need__escape__scalar(str, escape_slash, 0, str.length);
}
function _M0FPC14json14write__escaped(buf, str, escape_slash) {
  if (!_M0FPC14json12need__escape(str, escape_slash)) {
    _M0IPB13StringBuilderPB6Logger13write__string(buf, str);
    return undefined;
  }
  const _bind = str.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const code = str.charCodeAt(_);
      switch (code) {
        case 34: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\\"");
          break;
        }
        case 92: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\\\");
          break;
        }
        case 47: {
          if (escape_slash) {
            _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\/");
          } else {
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 47);
          }
          break;
        }
        case 10: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\n");
          break;
        }
        case 13: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\r");
          break;
        }
        case 8: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\b");
          break;
        }
        case 9: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\t");
          break;
        }
        case 12: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\f");
          break;
        }
        default: {
          if (code < 32) {
            _M0IPB13StringBuilderPB6Logger13write__string(buf, "\\u00");
            _M0IPB13StringBuilderPB6Logger13write__string(buf, _M0MPC14byte4Byte7to__hex(code & 255));
          } else {
            _M0IPB13StringBuilderPB6Logger11write__char(buf, code);
          }
        }
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FPC14json13write__indent(buf, cache, level, indent) {
  while (true) {
    if (cache.length <= level) {
      if (cache.length >= 1) {
        const _last = cache[cache.length - 1 | 0];
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(cache, `${_last}${_M0MPC16string6String6repeat(" ", indent)}`);
      } else {
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(cache, "\n");
      }
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger13write__string(buf, _M0MPC15array5Array2atGRPB4JsonE(cache, level));
}
function _M0MPC14json4Json17stringify_2einner(self, escape_slash, indent, replacer) {
  const buf = _M0MPB13StringBuilder21StringBuilder_2einner(0);
  const indent_cache = [];
  const stack = [];
  let depth = 0;
  let _tmp = self;
  while (true) {
    const x = _tmp;
    if (x === undefined) {
      if (stack.length === 0) {
        break;
      } else {
        const _x = stack[stack.length - 1 | 0];
        if (_x.$tag === 0) {
          const _Array = _x;
          const _arr = _Array._0;
          const _i = _Array._1;
          if (_i < _arr.length) {
            const element = _M0MPC15array5Array2atGRPB4JsonE(_arr, _i);
            _Array._1 = _i + 1 | 0;
            if (_i > 0) {
              _M0IPB13StringBuilderPB6Logger11write__char(buf, 44);
              if (indent > 0) {
                _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
              }
            }
            _tmp = element;
            continue;
          } else {
            depth = depth - 1 | 0;
            _M0MPC15array5Array3popGRPC14json10WriteFrameE(stack);
            if (indent > 0) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 93);
            _tmp = undefined;
            continue;
          }
        } else {
          const _Object = _x;
          const _iterator = _Object._0;
          const _first = _Object._1;
          const _bind = _M0MPB4Iter4nextGUsRPB4JsonEE(_iterator);
          if (_bind === undefined) {
            depth = depth - 1 | 0;
            _M0MPC15array5Array3popGRPC14json10WriteFrameE(stack);
            if (indent > 0) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 125);
            _tmp = undefined;
            continue;
          } else {
            const _Some = _bind;
            const _x$2 = _Some;
            const _k = _x$2._0;
            const _v = _x$2._1;
            let v2 = _v;
            if (replacer === undefined) {
            } else {
              const _Some$2 = replacer;
              const _replacer = _Some$2;
              const _func = _replacer.f;
              const _bind$2 = _func(_k, _v);
              if (_bind$2 === undefined) {
                _tmp = undefined;
                continue;
              } else {
                const _Some$3 = _bind$2;
                const _v$2 = _Some$3;
                v2 = _v$2;
              }
            }
            if (!_first) {
              _M0IPB13StringBuilderPB6Logger11write__char(buf, 44);
              if (indent > 0) {
                _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
              }
            }
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
            _M0FPC14json14write__escaped(buf, _k, escape_slash);
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 58);
            if (indent > 0) {
              _M0IPB13StringBuilderPB6Logger11write__char(buf, 32);
            }
            _Object._1 = false;
            _tmp = v2;
            continue;
          }
        }
      }
    } else {
      const _Some = x;
      const _value = _Some;
      switch (_value.$tag) {
        case 6: {
          const _Object = _value;
          const _members = _Object._0;
          if (_members.size === 0) {
            _M0IPB13StringBuilderPB6Logger13write__string(buf, "{}");
          } else {
            depth = depth + 1 | 0;
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 123);
            if (indent > 0) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(stack, new _M0DTPC14json10WriteFrame6Object(_M0MPB3Map4iterGsRPB4JsonE(_members), true));
          }
          break;
        }
        case 5: {
          const _Array = _value;
          const _arr = _Array._0;
          if (_arr.length === 0) {
            _M0IPB13StringBuilderPB6Logger13write__string(buf, "[]");
          } else {
            depth = depth + 1 | 0;
            _M0IPB13StringBuilderPB6Logger11write__char(buf, 91);
            if (indent > 0) {
              _M0FPC14json13write__indent(buf, indent_cache, depth, indent);
            }
            _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(stack, new _M0DTPC14json10WriteFrame5Array(_arr, 0));
          }
          break;
        }
        case 4: {
          const _String = _value;
          const _s = _String._0;
          _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
          _M0FPC14json14write__escaped(buf, _s, escape_slash);
          _M0IPB13StringBuilderPB6Logger11write__char(buf, 34);
          break;
        }
        case 3: {
          const _Number = _value;
          const _n = _Number._0;
          const _repr = _Number._1;
          if (_repr === undefined) {
            _M0MPB13StringBuilder13write__objectGdE(buf, _n);
          } else {
            const _Some$2 = _repr;
            const _r = _Some$2;
            _M0IPB13StringBuilderPB6Logger13write__string(buf, _r);
          }
          break;
        }
        case 1: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "true");
          break;
        }
        case 2: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "false");
          break;
        }
        default: {
          _M0IPB13StringBuilderPB6Logger13write__string(buf, "null");
        }
      }
      _tmp = undefined;
      continue;
    }
  }
  return buf.val;
}
function _M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(_x_364, _x_365) {
  switch (_x_364) {
    case 0: {
      if (_x_365 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_365 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_365 === 2) {
        return true;
      } else {
        return false;
      }
    }
    case 3: {
      if (_x_365 === 3) {
        return true;
      } else {
        return false;
      }
    }
    case 4: {
      if (_x_365 === 4) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_365 === 5) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0IP26Ljh68411sqlsentinel7DialectPB2Eq5equal(_x_360, _x_361) {
  switch (_x_360) {
    case 0: {
      if (_x_361 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_361 === 1) {
        return true;
      } else {
        return false;
      }
    }
    case 2: {
      if (_x_361 === 2) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_361 === 3) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0IP26Ljh68411sqlsentinel8SeverityPB2Eq5equal(_x_356, _x_357) {
  switch (_x_356) {
    case 0: {
      if (_x_357 === 0) {
        return true;
      } else {
        return false;
      }
    }
    case 1: {
      if (_x_357 === 1) {
        return true;
      } else {
        return false;
      }
    }
    default: {
      if (_x_357 === 2) {
        return true;
      } else {
        return false;
      }
    }
  }
}
function _M0MP26Ljh68411sqlsentinel8Severity4rank(self) {
  switch (self) {
    case 0: {
      return 1;
    }
    case 1: {
      return 2;
    }
    default: {
      return 3;
    }
  }
}
function _M0MP26Ljh68411sqlsentinel8Severity5label(self) {
  switch (self) {
    case 0: {
      return "info";
    }
    case 1: {
      return "warning";
    }
    default: {
      return "error";
    }
  }
}
function _M0MP26Ljh68411sqlsentinel7Dialect5label(self) {
  switch (self) {
    case 0: {
      return "auto";
    }
    case 1: {
      return "postgres";
    }
    case 2: {
      return "mysql";
    }
    default: {
      return "sqlite";
    }
  }
}
function _M0MP26Ljh68411sqlsentinel7Dialect5parse(value) {
  _L: {
    _L$2: {
      _L$3: {
        const _bind = _M0MPC16string6String4trim(value, undefined);
        if ((_bind.end - _bind.start | 0) === 4) {
          const _x = _bind.str.charCodeAt(_bind.start);
          if (_x === 97) {
            const _x$2 = _bind.str.charCodeAt(_bind.start + 1 | 0);
            if (_x$2 === 117) {
              const _x$3 = _bind.str.charCodeAt(_bind.start + 2 | 0);
              if (_x$3 === 116) {
                const _x$4 = _bind.str.charCodeAt(_bind.start + 3 | 0);
                if (_x$4 === 111) {
                  return _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS985;
                } else {
                  break _L;
                }
              } else {
                break _L;
              }
            } else {
              break _L;
            }
          } else {
            break _L;
          }
        } else {
          if ((_bind.end - _bind.start | 0) === 8) {
            const _x = _bind.str.charCodeAt(_bind.start);
            if (_x === 112) {
              const _x$2 = _bind.str.charCodeAt(_bind.start + 1 | 0);
              if (_x$2 === 111) {
                const _x$3 = _bind.str.charCodeAt(_bind.start + 2 | 0);
                if (_x$3 === 115) {
                  const _x$4 = _bind.str.charCodeAt(_bind.start + 3 | 0);
                  if (_x$4 === 116) {
                    const _x$5 = _bind.str.charCodeAt(_bind.start + 4 | 0);
                    if (_x$5 === 103) {
                      const _x$6 = _bind.str.charCodeAt(_bind.start + 5 | 0);
                      if (_x$6 === 114) {
                        const _x$7 = _bind.str.charCodeAt(_bind.start + 6 | 0);
                        if (_x$7 === 101) {
                          const _x$8 = _bind.str.charCodeAt(_bind.start + 7 | 0);
                          if (_x$8 === 115) {
                            break _L$3;
                          } else {
                            break _L;
                          }
                        } else {
                          break _L;
                        }
                      } else {
                        break _L;
                      }
                    } else {
                      break _L;
                    }
                  } else {
                    break _L;
                  }
                } else {
                  break _L;
                }
              } else {
                break _L;
              }
            } else {
              break _L;
            }
          } else {
            if ((_bind.end - _bind.start | 0) === 10) {
              const _x = _bind.str.charCodeAt(_bind.start);
              if (_x === 112) {
                const _x$2 = _bind.str.charCodeAt(_bind.start + 1 | 0);
                if (_x$2 === 111) {
                  const _x$3 = _bind.str.charCodeAt(_bind.start + 2 | 0);
                  if (_x$3 === 115) {
                    const _x$4 = _bind.str.charCodeAt(_bind.start + 3 | 0);
                    if (_x$4 === 116) {
                      const _x$5 = _bind.str.charCodeAt(_bind.start + 4 | 0);
                      if (_x$5 === 103) {
                        const _x$6 = _bind.str.charCodeAt(_bind.start + 5 | 0);
                        if (_x$6 === 114) {
                          const _x$7 = _bind.str.charCodeAt(_bind.start + 6 | 0);
                          if (_x$7 === 101) {
                            const _x$8 = _bind.str.charCodeAt(_bind.start + 7 | 0);
                            if (_x$8 === 115) {
                              const _x$9 = _bind.str.charCodeAt(_bind.start + 8 | 0);
                              if (_x$9 === 113) {
                                const _x$10 = _bind.str.charCodeAt(_bind.start + 9 | 0);
                                if (_x$10 === 108) {
                                  break _L$3;
                                } else {
                                  break _L;
                                }
                              } else {
                                break _L;
                              }
                            } else {
                              break _L;
                            }
                          } else {
                            break _L;
                          }
                        } else {
                          break _L;
                        }
                      } else {
                        break _L;
                      }
                    } else {
                      break _L;
                    }
                  } else {
                    break _L;
                  }
                } else {
                  break _L;
                }
              } else {
                break _L;
              }
            } else {
              if ((_bind.end - _bind.start | 0) === 2) {
                const _x = _bind.str.charCodeAt(_bind.start);
                if (_x === 112) {
                  const _x$2 = _bind.str.charCodeAt(_bind.start + 1 | 0);
                  if (_x$2 === 103) {
                    break _L$3;
                  } else {
                    break _L;
                  }
                } else {
                  break _L;
                }
              } else {
                if ((_bind.end - _bind.start | 0) === 5) {
                  const _x = _bind.str.charCodeAt(_bind.start);
                  if (_x === 109) {
                    const _x$2 = _bind.str.charCodeAt(_bind.start + 1 | 0);
                    if (_x$2 === 121) {
                      const _x$3 = _bind.str.charCodeAt(_bind.start + 2 | 0);
                      if (_x$3 === 115) {
                        const _x$4 = _bind.str.charCodeAt(_bind.start + 3 | 0);
                        if (_x$4 === 113) {
                          const _x$5 = _bind.str.charCodeAt(_bind.start + 4 | 0);
                          if (_x$5 === 108) {
                            return _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS986;
                          } else {
                            break _L;
                          }
                        } else {
                          break _L;
                        }
                      } else {
                        break _L;
                      }
                    } else {
                      break _L;
                    }
                  } else {
                    break _L;
                  }
                } else {
                  if ((_bind.end - _bind.start | 0) === 6) {
                    const _x = _bind.str.charCodeAt(_bind.start);
                    if (_x === 115) {
                      const _x$2 = _bind.str.charCodeAt(_bind.start + 1 | 0);
                      if (_x$2 === 113) {
                        const _x$3 = _bind.str.charCodeAt(_bind.start + 2 | 0);
                        if (_x$3 === 108) {
                          const _x$4 = _bind.str.charCodeAt(_bind.start + 3 | 0);
                          if (_x$4 === 105) {
                            const _x$5 = _bind.str.charCodeAt(_bind.start + 4 | 0);
                            if (_x$5 === 116) {
                              const _x$6 = _bind.str.charCodeAt(_bind.start + 5 | 0);
                              if (_x$6 === 101) {
                                break _L$2;
                              } else {
                                break _L;
                              }
                            } else {
                              break _L;
                            }
                          } else {
                            break _L;
                          }
                        } else {
                          break _L;
                        }
                      } else {
                        break _L;
                      }
                    } else {
                      break _L;
                    }
                  } else {
                    if ((_bind.end - _bind.start | 0) === 7) {
                      const _x = _bind.str.charCodeAt(_bind.start);
                      if (_x === 115) {
                        const _x$2 = _bind.str.charCodeAt(_bind.start + 1 | 0);
                        if (_x$2 === 113) {
                          const _x$3 = _bind.str.charCodeAt(_bind.start + 2 | 0);
                          if (_x$3 === 108) {
                            const _x$4 = _bind.str.charCodeAt(_bind.start + 3 | 0);
                            if (_x$4 === 105) {
                              const _x$5 = _bind.str.charCodeAt(_bind.start + 4 | 0);
                              if (_x$5 === 116) {
                                const _x$6 = _bind.str.charCodeAt(_bind.start + 5 | 0);
                                if (_x$6 === 101) {
                                  const _x$7 = _bind.str.charCodeAt(_bind.start + 6 | 0);
                                  if (_x$7 === 51) {
                                    break _L$2;
                                  } else {
                                    break _L;
                                  }
                                } else {
                                  break _L;
                                }
                              } else {
                                break _L;
                              }
                            } else {
                              break _L;
                            }
                          } else {
                            break _L;
                          }
                        } else {
                          break _L;
                        }
                      } else {
                        break _L;
                      }
                    } else {
                      break _L;
                    }
                  }
                }
              }
            }
          }
        }
      }
      return _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS984;
    }
    return _M0MP26Ljh68411sqlsentinel7Dialect5parseN6constrS983;
  }
  return undefined;
}
function _M0MP26Ljh68411sqlsentinel11ScanOptions11new_2einner(allow_destructive, style_checks, ignored_rules, dialect) {
  return new _M0TP26Ljh68411sqlsentinel11ScanOptions(allow_destructive, style_checks, ignored_rules, dialect);
}
function _M0MP26Ljh68411sqlsentinel11ScanOptions3new(allow_destructive$46$opt, style_checks$46$opt, ignored_rules$46$opt, dialect$46$opt) {
  const allow_destructive = allow_destructive$46$opt === -1 ? false : allow_destructive$46$opt;
  const style_checks = style_checks$46$opt === -1 ? true : style_checks$46$opt;
  let ignored_rules;
  if (ignored_rules$46$opt.$tag === 1) {
    const _Some = ignored_rules$46$opt;
    ignored_rules = _Some._0;
  } else {
    ignored_rules = [];
  }
  let dialect;
  if (dialect$46$opt === undefined) {
    dialect = 0;
  } else {
    const _Some = dialect$46$opt;
    dialect = _Some;
  }
  return _M0MP26Ljh68411sqlsentinel11ScanOptions11new_2einner(allow_destructive, style_checks, ignored_rules, dialect);
}
function _M0MP26Ljh68411sqlsentinel6Report17highest__severity(self) {
  return self.error_count > 0 ? _M0MP26Ljh68411sqlsentinel6Report17highest__severityN6constrS991 : self.warning_count > 0 ? _M0MP26Ljh68411sqlsentinel6Report17highest__severityN6constrS992 : self.info_count > 0 ? _M0MP26Ljh68411sqlsentinel6Report17highest__severityN6constrS993 : undefined;
}
function _M0FP26Ljh68411sqlsentinel12json__string(value) {
  return new _M0DTPB4Json6String(value);
}
function _M0FP26Ljh68411sqlsentinel9json__int(value) {
  const _p = value + 0;
  const _p$2 = _M0MPC13int3Int18to__string_2einner(value, 10);
  return new _M0DTPB4Json6Number(_p, _p$2);
}
function _M0FP26Ljh68411sqlsentinel12json__object(fields) {
  const _p = _M0MPB3Map3MapGsRPB4JsonE(new _M0TPB9ArrayViewGUsRPB4JsonEE(fields, 0, fields.length), undefined);
  return new _M0DTPB4Json6Object(_p);
}
function _M0FP26Ljh68411sqlsentinel13finding__json(finding) {
  return _M0FP26Ljh68411sqlsentinel12json__object([{ _0: "rule_id", _1: _M0FP26Ljh68411sqlsentinel12json__string(finding.rule_id) }, { _0: "title", _1: _M0FP26Ljh68411sqlsentinel12json__string(finding.title) }, { _0: "severity", _1: _M0FP26Ljh68411sqlsentinel12json__string(_M0MP26Ljh68411sqlsentinel8Severity5label(finding.severity)) }, { _0: "statement", _1: _M0FP26Ljh68411sqlsentinel9json__int(finding.statement_index) }, { _0: "line", _1: _M0FP26Ljh68411sqlsentinel9json__int(finding.line) }, { _0: "column", _1: _M0FP26Ljh68411sqlsentinel9json__int(finding.column) }, { _0: "message", _1: _M0FP26Ljh68411sqlsentinel12json__string(finding.message) }, { _0: "suggestion", _1: _M0FP26Ljh68411sqlsentinel12json__string(finding.suggestion) }, { _0: "evidence", _1: _M0FP26Ljh68411sqlsentinel12json__string(finding.evidence) }]);
}
function _M0FP26Ljh68411sqlsentinel22suppressed__rule__json(rule) {
  return _M0FP26Ljh68411sqlsentinel12json__object([{ _0: "rule_id", _1: _M0FP26Ljh68411sqlsentinel12json__string(rule.rule_id) }, { _0: "count", _1: _M0FP26Ljh68411sqlsentinel9json__int(rule.count) }]);
}
function _M0FP26Ljh68411sqlsentinel12report__json(report) {
  const _bind = _M0MP26Ljh68411sqlsentinel6Report17highest__severity(report);
  let highest;
  if (_bind === undefined) {
    highest = _M0DTPB4Json4Null__;
  } else {
    const _Some = _bind;
    const _severity = _Some;
    highest = _M0FP26Ljh68411sqlsentinel12json__string(_M0MP26Ljh68411sqlsentinel8Severity5label(_severity));
  }
  const _tmp = { _0: "schema_version", _1: _M0FP26Ljh68411sqlsentinel12json__string("1.0") };
  const _tmp$2 = { _0: "tool", _1: _M0FP26Ljh68411sqlsentinel12json__string("SQLSentinel") };
  const _tmp$3 = { _0: "statements", _1: _M0FP26Ljh68411sqlsentinel9json__int(report.statement_count) };
  const _tmp$4 = { _0: "errors", _1: _M0FP26Ljh68411sqlsentinel9json__int(report.error_count) };
  const _tmp$5 = { _0: "warnings", _1: _M0FP26Ljh68411sqlsentinel9json__int(report.warning_count) };
  const _tmp$6 = { _0: "infos", _1: _M0FP26Ljh68411sqlsentinel9json__int(report.info_count) };
  const _tmp$7 = { _0: "suppressed", _1: _M0FP26Ljh68411sqlsentinel9json__int(report.suppressed_count) };
  const _tmp$8 = { _0: "dialect", _1: _M0FP26Ljh68411sqlsentinel12json__string(_M0MP26Ljh68411sqlsentinel7Dialect5label(report.dialect)) };
  const _tmp$9 = { _0: "highest_severity", _1: highest };
  const _p = report.suppressions;
  const _p$2 = new Array(_p.length);
  const _p$3 = _p.length;
  let _tmp$10 = 0;
  while (true) {
    const _p$4 = _tmp$10;
    if (_p$4 < _p$3) {
      const _p$5 = _p[_p$4];
      _p$2[_p$4] = _M0FP26Ljh68411sqlsentinel22suppressed__rule__json(_p$5);
      _tmp$10 = _p$4 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$4 = _p$2;
  const _tmp$11 = { _0: "summary", _1: _M0FP26Ljh68411sqlsentinel12json__object([_tmp$3, _tmp$4, _tmp$5, _tmp$6, _tmp$7, _tmp$8, _tmp$9, { _0: "suppressions", _1: new _M0DTPB4Json5Array(_p$4) }]) };
  const _p$5 = report.findings;
  const _p$6 = new Array(_p$5.length);
  const _p$7 = _p$5.length;
  let _tmp$12 = 0;
  while (true) {
    const _p$8 = _tmp$12;
    if (_p$8 < _p$7) {
      const _p$9 = _p$5[_p$8];
      _p$6[_p$8] = _M0FP26Ljh68411sqlsentinel13finding__json(_p$9);
      _tmp$12 = _p$8 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p$8 = _p$6;
  return _M0FP26Ljh68411sqlsentinel12json__object([_tmp, _tmp$2, _tmp$11, { _0: "findings", _1: new _M0DTPB4Json5Array(_p$8) }]);
}
function _M0FP26Ljh68411sqlsentinel16report__to__json(report) {
  return _M0MPC14json4Json17stringify_2einner(_M0FP26Ljh68411sqlsentinel12report__json(report), false, 2, undefined);
}
function _M0FP26Ljh68411sqlsentinel14markdown__cell(value) {
  return _M0MPC16string6String12replace__all(_M0MPC16string6String12replace__all(value, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS541, 0, _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS541.length), new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS542, 0, _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS542.length)), new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS543, 0, _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS543.length), new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS544, 0, _M0FP26Ljh68411sqlsentinel14markdown__cellN7_2abindS544.length));
}
function _M0FP26Ljh68411sqlsentinel28report__to__markdown_2einner(report, path) {
  const builder = _M0MPB13StringBuilder21StringBuilder_2einner(0);
  const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(24);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "# SQLSentinel review: ");
  _M0MPB13StringBuilder13write__objectGsE(_string_builder, path);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "\n\n");
  _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder.val);
  const _string_builder$2 = _M0MPB13StringBuilder21StringBuilder_2einner(100);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, "Dialect: `");
  _M0MPB13StringBuilder13write__objectGsE(_string_builder$2, _M0MP26Ljh68411sqlsentinel7Dialect5label(report.dialect));
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, "`. Scanned **");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, report.statement_count);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, "** statements and found **");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, report.error_count);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, " errors**, **");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, report.warning_count);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, " warnings**, and **");
  _M0MPB13StringBuilder13write__objectGiE(_string_builder$2, report.info_count);
  _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$2, " info** findings.\n\n");
  _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$2.val);
  if (report.suppressed_count > 0) {
    const _string_builder$3 = _M0MPB13StringBuilder21StringBuilder_2einner(29);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, "**Suppressed:** ");
    _M0MPB13StringBuilder13write__objectGiE(_string_builder$3, report.suppressed_count);
    _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, " finding(s) -");
    _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$3.val);
    const _bind = report.suppressions;
    const _bind$2 = _bind.length;
    let _tmp = 0;
    while (true) {
      const _ = _tmp;
      if (_ < _bind$2) {
        const rule = _bind[_];
        const _string_builder$4 = _M0MPB13StringBuilder21StringBuilder_2einner(5);
        _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$4, " `");
        _M0MPB13StringBuilder13write__objectGsE(_string_builder$4, rule.rule_id);
        _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$4, "` x");
        _M0MPB13StringBuilder13write__objectGiE(_string_builder$4, rule.count);
        _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$4.val);
        _tmp = _ + 1 | 0;
        continue;
      } else {
        break;
      }
    }
    _M0IPB13StringBuilderPB6Logger13write__string(builder, "\n\n");
  }
  const _p = report.findings;
  if (_p.length === 0) {
    if (report.suppressed_count > 0) {
      _M0IPB13StringBuilderPB6Logger13write__string(builder, "No unsuppressed policy findings. The SQL passed this review.\n");
    } else {
      _M0IPB13StringBuilderPB6Logger13write__string(builder, "No policy findings. The SQL passed this review.\n");
    }
    return builder.val;
  }
  _M0IPB13StringBuilderPB6Logger13write__string(builder, "| Location | Severity | Rule | Finding |\n");
  _M0IPB13StringBuilderPB6Logger13write__string(builder, "| --- | --- | --- | --- |\n");
  const _bind = report.findings;
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const finding = _bind[_];
      const _string_builder$3 = _M0MPB13StringBuilder21StringBuilder_2einner(16);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, "| L");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$3, finding.line);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, ":");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$3, finding.column);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, " | ");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$3, _M0MP26Ljh68411sqlsentinel8Severity5label(finding.severity));
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, " | ");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$3, finding.rule_id);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, " | ");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$3, _M0FP26Ljh68411sqlsentinel14markdown__cell(finding.title));
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, " |\n");
      _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$3.val);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0IPB13StringBuilderPB6Logger13write__string(builder, "\n## Review details\n");
  const _bind$3 = report.findings;
  const _bind$4 = _bind$3.length;
  let _tmp$2 = 0;
  while (true) {
    const _ = _tmp$2;
    if (_ < _bind$4) {
      const finding = _bind$3[_];
      const _string_builder$3 = _M0MPB13StringBuilder21StringBuilder_2einner(11);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, "\n### ");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$3, finding.rule_id);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, " · ");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$3, finding.title);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$3, "\n\n");
      _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$3.val);
      const _string_builder$4 = _M0MPB13StringBuilder21StringBuilder_2einner(43);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$4, "- **Location:** statement ");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$4, finding.statement_index);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$4, ", line ");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$4, finding.line);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$4, ", column ");
      _M0MPB13StringBuilder13write__objectGiE(_string_builder$4, finding.column);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$4, "\n");
      _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$4.val);
      const _string_builder$5 = _M0MPB13StringBuilder21StringBuilder_2einner(13);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$5, "- **Risk:** ");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$5, finding.message);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$5, "\n");
      _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$5.val);
      const _string_builder$6 = _M0MPB13StringBuilder21StringBuilder_2einner(19);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$6, "- **Evidence:** `");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$6, _M0MPC16string6String12replace__all(finding.evidence, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel28report__to__markdown_2einnerN7_2abindS574, 0, _M0FP26Ljh68411sqlsentinel28report__to__markdown_2einnerN7_2abindS574.length), new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel28report__to__markdown_2einnerN7_2abindS575, 0, _M0FP26Ljh68411sqlsentinel28report__to__markdown_2einnerN7_2abindS575.length)));
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$6, "`\n");
      _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$6.val);
      const _string_builder$7 = _M0MPB13StringBuilder21StringBuilder_2einner(25);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$7, "- **Suggested action:** ");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder$7, finding.suggestion);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder$7, "\n");
      _M0IPB13StringBuilderPB6Logger13write__string(builder, _string_builder$7.val);
      _tmp$2 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return builder.val;
}
function _M0FP26Ljh68411sqlsentinel15is__word__start(ch) {
  return _M0MPC14char4Char21is__ascii__alphabetic(ch) || ch === 95;
}
function _M0FP26Ljh68411sqlsentinel14is__word__part(ch) {
  return _M0MPC14char4Char21is__ascii__alphabetic(ch) || (_M0MPC14char4Char16is__ascii__digit(ch) || (ch === 95 || ch === 36));
}
function _M0FP26Ljh68411sqlsentinel22identifier__quote__end(ch) {
  if (ch === 91) {
    return 93;
  } else {
    return ch;
  }
}
function _M0FP26Ljh68411sqlsentinel24read__quoted__identifier(chars, start) {
  const open = _M0MPC15array5Array2atGcE(chars, start);
  const close = _M0FP26Ljh68411sqlsentinel22identifier__quote__end(open);
  const builder = _M0MPB13StringBuilder21StringBuilder_2einner(0);
  let i = start + 1 | 0;
  while (true) {
    if (i < chars.length) {
      const ch = _M0MPC15array5Array2atGcE(chars, i);
      if (ch === close) {
        if (close !== 93 && ((i + 1 | 0) < chars.length && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === close)) {
          _M0IPB13StringBuilderPB6Logger11write__char(builder, close);
          i = i + 2 | 0;
        } else {
          return { _0: i + 1 | 0, _1: builder.val };
        }
      } else {
        _M0IPB13StringBuilderPB6Logger11write__char(builder, ch);
        i = i + 1 | 0;
      }
      continue;
    } else {
      break;
    }
  }
  return { _0: i, _1: builder.val };
}
function _M0FP26Ljh68411sqlsentinel21read__string__literal(chars, start) {
  const builder = _M0MPB13StringBuilder21StringBuilder_2einner(0);
  let i = start + 1 | 0;
  while (true) {
    if (i < chars.length) {
      const ch = _M0MPC15array5Array2atGcE(chars, i);
      if (ch === 39) {
        if ((i + 1 | 0) < chars.length && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === 39) {
          _M0IPB13StringBuilderPB6Logger11write__char(builder, 39);
          i = i + 2 | 0;
        } else {
          return { _0: i + 1 | 0, _1: builder.val };
        }
      } else {
        if (ch === 92 && (i + 1 | 0) < chars.length) {
          _M0IPB13StringBuilderPB6Logger11write__char(builder, _M0MPC15array5Array2atGcE(chars, i + 1 | 0));
          i = i + 2 | 0;
        } else {
          _M0IPB13StringBuilderPB6Logger11write__char(builder, ch);
          i = i + 1 | 0;
        }
      }
      continue;
    } else {
      break;
    }
  }
  return { _0: i, _1: builder.val };
}
function _M0FP26Ljh68411sqlsentinel17dollar__delimiter(chars, start) {
  let i = start + 1 | 0;
  while (true) {
    if (i < chars.length) {
      const ch = _M0MPC15array5Array2atGcE(chars, i);
      if (ch === 36) {
        return _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, start, i + 1 | 0));
      }
      if (!(_M0MPC14char4Char21is__ascii__alphabetic(ch) || (_M0MPC14char4Char16is__ascii__digit(ch) || ch === 95))) {
        return undefined;
      }
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP26Ljh68411sqlsentinel20read__dollar__string(chars, start, delimiter) {
  const delimiter_chars = _M0MPC16string6String9to__array(delimiter);
  const body_start = start + delimiter_chars.length | 0;
  let i = body_start;
  while (true) {
    if ((i + delimiter_chars.length | 0) <= chars.length) {
      let matches = true;
      const _bind = delimiter_chars.length;
      let _tmp = 0;
      while (true) {
        const j = _tmp;
        if (j < _bind) {
          if (_M0MPC15array5Array2atGcE(chars, i + j | 0) !== _M0MPC15array5Array2atGcE(delimiter_chars, j)) {
            matches = false;
            break;
          }
          _tmp = j + 1 | 0;
          continue;
        } else {
          break;
        }
      }
      if (matches) {
        return { _0: i + delimiter_chars.length | 0, _1: _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, body_start, i)) };
      }
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: chars.length, _1: _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, body_start, chars.length)) };
}
function _M0FP26Ljh68411sqlsentinel25directive__comment__token(content, line, column) {
  const trimmed = _M0MPC16string6String4trim(content, undefined);
  return _M0MPC16string10StringView11has__prefix(_M0MPC16string10StringView9to__lower(trimmed), new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel25directive__comment__tokenN7_2abindS650, 0, _M0FP26Ljh68411sqlsentinel25directive__comment__tokenN7_2abindS650.length)) ? new _M0TP26Ljh68411sqlsentinel5Token(5, _M0MPC16string10StringView9to__owned(trimmed), _M0MPC16string10StringView9to__owned(_M0MPC16string10StringView9to__lower(trimmed)), line, column) : undefined;
}
function _M0FP26Ljh68411sqlsentinel8tokenize(source) {
  const chars = _M0MPC16string6String9to__array(source);
  const tokens = [];
  let i = 0;
  let line = 1;
  let column = 1;
  while (true) {
    if (i < chars.length) {
      const ch = _M0MPC15array5Array2atGcE(chars, i);
      if (ch === 10) {
        line = line + 1 | 0;
        column = 1;
        i = i + 1 | 0;
        continue;
      }
      if (_M0MPC14char4Char14is__whitespace(ch)) {
        i = i + 1 | 0;
        column = column + 1 | 0;
        continue;
      }
      if (ch === 45 && ((i + 1 | 0) < chars.length && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === 45)) {
        const comment_line = line;
        const comment_column = column;
        const content = _M0MPB13StringBuilder21StringBuilder_2einner(0);
        i = i + 2 | 0;
        column = column + 2 | 0;
        while (true) {
          if (i < chars.length && _M0MPC15array5Array2atGcE(chars, i) !== 10) {
            _M0IPB13StringBuilderPB6Logger11write__char(content, _M0MPC15array5Array2atGcE(chars, i));
            i = i + 1 | 0;
            column = column + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _bind = _M0FP26Ljh68411sqlsentinel25directive__comment__token(content.val, comment_line, comment_column);
        if (_bind === undefined) {
        } else {
          const _Some = _bind;
          const _token = _Some;
          _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, _token);
        }
        continue;
      }
      if (ch === 35 && !((i + 1 | 0) < chars.length && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === 62)) {
        const comment_line = line;
        const comment_column = column;
        const content = _M0MPB13StringBuilder21StringBuilder_2einner(0);
        i = i + 1 | 0;
        column = column + 1 | 0;
        while (true) {
          if (i < chars.length && _M0MPC15array5Array2atGcE(chars, i) !== 10) {
            _M0IPB13StringBuilderPB6Logger11write__char(content, _M0MPC15array5Array2atGcE(chars, i));
            i = i + 1 | 0;
            column = column + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _bind = _M0FP26Ljh68411sqlsentinel25directive__comment__token(content.val, comment_line, comment_column);
        if (_bind === undefined) {
        } else {
          const _Some = _bind;
          const _token = _Some;
          _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, _token);
        }
        continue;
      }
      if (ch === 47 && ((i + 1 | 0) < chars.length && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === 42)) {
        const comment_line = line;
        const comment_column = column;
        const content_start = i + 2 | 0;
        let depth = 1;
        i = i + 2 | 0;
        column = column + 2 | 0;
        while (true) {
          if (i < chars.length && depth > 0) {
            if ((i + 1 | 0) < chars.length && (_M0MPC15array5Array2atGcE(chars, i) === 47 && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === 42)) {
              depth = depth + 1 | 0;
              i = i + 2 | 0;
              column = column + 2 | 0;
            } else {
              if (_M0MPC15array5Array2atGcE(chars, i) === 42 && ((i + 1 | 0) < chars.length && _M0MPC15array5Array2atGcE(chars, i + 1 | 0) === 47)) {
                depth = depth - 1 | 0;
                i = i + 2 | 0;
                column = column + 2 | 0;
              } else {
                if (_M0MPC15array5Array2atGcE(chars, i) === 10) {
                  line = line + 1 | 0;
                  column = 1;
                  i = i + 1 | 0;
                } else {
                  i = i + 1 | 0;
                  column = column + 1 | 0;
                }
              }
            }
            continue;
          } else {
            break;
          }
        }
        const content_end = depth === 0 && i >= 2 ? i - 2 | 0 : i;
        const _bind = _M0FP26Ljh68411sqlsentinel25directive__comment__token(_M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, content_start, content_end)), comment_line, comment_column);
        if (_bind === undefined) {
        } else {
          const _Some = _bind;
          const _token = _Some;
          _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, _token);
        }
        continue;
      }
      const token_line = line;
      const token_column = column;
      if (_M0FP26Ljh68411sqlsentinel15is__word__start(ch)) {
        const start = i;
        while (true) {
          if (i < chars.length && _M0FP26Ljh68411sqlsentinel14is__word__part(_M0MPC15array5Array2atGcE(chars, i))) {
            i = i + 1 | 0;
            column = column + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const text = _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, start, i));
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, new _M0TP26Ljh68411sqlsentinel5Token(0, text, _M0MPC16string6String9to__upper(text), token_line, token_column));
        continue;
      }
      if (ch === 39) {
        const _bind = _M0FP26Ljh68411sqlsentinel21read__string__literal(chars, i);
        const _next = _bind._0;
        const _value = _bind._1;
        const length = _next - i | 0;
        i = _next;
        column = column + length | 0;
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, new _M0TP26Ljh68411sqlsentinel5Token(1, "'<literal>'", _value, token_line, token_column));
        continue;
      }
      if (ch === 34 || (ch === 96 || ch === 91)) {
        const _bind = _M0FP26Ljh68411sqlsentinel24read__quoted__identifier(chars, i);
        const _next = _bind._0;
        const _value = _bind._1;
        const length = _next - i | 0;
        i = _next;
        column = column + length | 0;
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, new _M0TP26Ljh68411sqlsentinel5Token(2, _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, i - length | 0, i)), _value, token_line, token_column));
        continue;
      }
      if (ch === 36) {
        const _bind = _M0FP26Ljh68411sqlsentinel17dollar__delimiter(chars, i);
        if (_bind === undefined) {
        } else {
          const _Some = _bind;
          const _delimiter = _Some;
          const _bind$2 = _M0FP26Ljh68411sqlsentinel20read__dollar__string(chars, i, _delimiter);
          const _next = _bind$2._0;
          const _value = _bind$2._1;
          const length = _next - i | 0;
          i = _next;
          column = column + length | 0;
          _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, new _M0TP26Ljh68411sqlsentinel5Token(1, "$<literal>$", _value, token_line, token_column));
          continue;
        }
      }
      if (_M0MPC14char4Char16is__ascii__digit(ch)) {
        const start = i;
        while (true) {
          if (i < chars.length && (_M0MPC14char4Char16is__ascii__digit(_M0MPC15array5Array2atGcE(chars, i)) || (_M0MPC15array5Array2atGcE(chars, i) === 46 || (_M0MPC15array5Array2atGcE(chars, i) === 101 || (_M0MPC15array5Array2atGcE(chars, i) === 69 || (_M0MPC15array5Array2atGcE(chars, i) === 43 || _M0MPC15array5Array2atGcE(chars, i) === 45)))))) {
            i = i + 1 | 0;
            column = column + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const text = _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, start, i));
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, new _M0TP26Ljh68411sqlsentinel5Token(3, text, text, token_line, token_column));
        continue;
      }
      let symbol = _M0IPC14char4CharPB4Show10to__string(ch);
      if ((i + 1 | 0) < chars.length) {
        const pair = _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, i, i + 2 | 0));
        _L: {
          _L$2: {
            switch (pair) {
              case "<=": {
                break _L$2;
              }
              case ">=": {
                break _L$2;
              }
              case "<>": {
                break _L$2;
              }
              case "!=": {
                break _L$2;
              }
              case "::": {
                break _L$2;
              }
              case "->": {
                break _L$2;
              }
              case "=>": {
                break _L$2;
              }
              case "||": {
                break _L$2;
              }
              case "&&": {
                break _L$2;
              }
              case "#>": {
                break _L$2;
              }
            }
            break _L;
          }
          symbol = pair;
          i = i + 1 | 0;
          column = column + 1 | 0;
        }
      }
      _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(tokens, new _M0TP26Ljh68411sqlsentinel5Token(4, symbol, symbol, token_line, token_column));
      i = i + 1 | 0;
      column = column + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return tokens;
}
function _M0FP26Ljh68411sqlsentinel17split__statements(tokens) {
  const statements = [];
  let current = [];
  const _bind = tokens.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const token = tokens[_];
      _L: {
        if (_M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(token.kind, 5)) {
          break _L;
        } else {
          if (_M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(token.kind, 4) && token.text === ";") {
            const _p = current;
            if (!(_p.length === 0)) {
              _M0MPC15array5Array4pushGRPB5ArrayGRP26Ljh68411sqlsentinel5TokenEE(statements, current);
              current = [];
            }
          } else {
            _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(current, token);
          }
        }
        break _L;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _p = current;
  if (!(_p.length === 0)) {
    _M0MPC15array5Array4pushGRPB5ArrayGRP26Ljh68411sqlsentinel5TokenEE(statements, current);
  }
  return statements;
}
function _M0FP26Ljh68411sqlsentinel15token__is__word(token, word) {
  return _M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(token.kind, 0) && token.value === word;
}
function _M0FP26Ljh68411sqlsentinel17token__is__symbol(token, symbol) {
  return _M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(token.kind, 4) && token.text === symbol;
}
function _M0FP26Ljh68411sqlsentinel19statement__evidence(tokens) {
  const builder = _M0MPB13StringBuilder21StringBuilder_2einner(0);
  const limit = tokens.length < 18 ? tokens.length : 18;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < limit) {
      if (i > 0) {
        _M0IPB13StringBuilderPB6Logger11write__char(builder, 32);
      }
      _M0IPB13StringBuilderPB6Logger13write__string(builder, _M0MPC15array5Array2atGRPB4JsonE(tokens, i).text);
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (limit < tokens.length) {
    _M0IPB13StringBuilderPB6Logger13write__string(builder, " ...");
  }
  const result = builder.val;
  return _M0MPC16string6String20char__length_2einner(result, 0, undefined) > 160 ? `${_M0MPC16string10StringView9to__owned(_M0MPC16string6String21clamped__view_2einner(result, 0, _M0FP26Ljh68411sqlsentinel19statement__evidenceN6constrS1003))}...` : result;
}
function _M0FP26Ljh68411sqlsentinel15known__rule__id(rule_id) {
  const _bind = [_M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS994, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS995, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS996, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS997, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS998, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS999, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS1000, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS1001, _M0FP26Ljh68411sqlsentinel13rule__catalogN6recordS1002];
  const _bind$2 = _bind.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const rule = _bind[_];
      if (rule.id === rule_id) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FP26Ljh68411sqlsentinel25split__command__and__args(value) {
  const chars = _M0MPC16string6String9to__array(value);
  let split = chars.length;
  const _bind = chars.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      if (_M0MPC14char4Char14is__whitespace(_M0MPC15array5Array2atGcE(chars, i))) {
        split = i;
        break;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return { _0: _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, 0, split)), _1: _M0MPC16string6String11from__array(_M0MPC15array5Array21clamped__view_2einnerGcE(chars, split, chars.length)) };
}
function _M0FP26Ljh68411sqlsentinel24parse__ignore__directive(token) {
  const _bind = _M0MPC16string6String11split__once(token.text, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN7_2abindS730, 0, _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN7_2abindS730.length));
  if (_bind === undefined) {
    return _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN6constrS1004;
  } else {
    const _Some = _bind;
    const _x = _Some;
    const _raw_args = _x._1;
    const args = _M0MPC16string10StringView4trim(_raw_args, undefined);
    const _bind$2 = _M0FP26Ljh68411sqlsentinel25split__command__and__args(_M0MPC16string10StringView9to__owned(args));
    const _command = _bind$2._0;
    const _raw_rules = _bind$2._1;
    const _p = _M0MPC16string6String9to__lower(_command);
    const _p$2 = "ignore";
    if (!(_p === _p$2)) {
      const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(52);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "unsupported directive '");
      _M0MPB13StringBuilder13write__objectGsE(_string_builder, _command);
      _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "'; only 'ignore' is supported");
      return new _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Rejected(_string_builder.val);
    }
    const rules = [];
    const _it = _M0MPC16string6String5split(_raw_rules, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN7_2abindS724, 0, _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN7_2abindS724.length));
    while (true) {
      const _bind$3 = _M0MPB4Iter4nextGUsRPB4JsonEE(_it);
      if (_bind$3 === undefined) {
        break;
      } else {
        const _Some$2 = _bind$3;
        const _raw_rule = _Some$2;
        const trimmed = _M0MPC16string10StringView4trim(_raw_rule, undefined);
        let _tmp;
        if ((trimmed.end - trimmed.start | 0) === 0) {
          _tmp = true;
        } else {
          let _tmp$2;
          let _p$3;
          _L: {
            _L$2: {
              const _p$4 = trimmed.str;
              const _p$5 = trimmed.start;
              const _p$6 = trimmed.end;
              let _tmp$3 = _p$5;
              while (true) {
                const _p$7 = _tmp$3;
                if (_p$7 < _p$6) {
                  let _p$8;
                  let _p$9;
                  _L$3: {
                    const _p$10 = _p$4.charCodeAt(_p$7);
                    if (_p$10 >= 55296 && _p$10 <= 56319 && (_p$7 + 1 | 0) < _p$6) {
                      const _p$11 = _p$4.charCodeAt(_p$7 + 1 | 0);
                      if (_p$11 >= 56320 && _p$11 <= 57343) {
                        const _tmp$4 = _p$7 + 2 | 0;
                        const _p$12 = (((Math.imul(_p$10 - 55296 | 0, 1024) | 0) + _p$11 | 0) - 56320 | 0) + 65536 | 0;
                        _p$8 = _tmp$4;
                        _p$9 = _p$12;
                        break _L$3;
                      } else {
                        const _tmp$4 = _p$7 + 1 | 0;
                        const _p$12 = _p$10;
                        _p$8 = _tmp$4;
                        _p$9 = _p$12;
                        break _L$3;
                      }
                    } else {
                      const _tmp$4 = _p$7 + 1 | 0;
                      const _p$11 = _p$10;
                      _p$8 = _tmp$4;
                      _p$9 = _p$11;
                      break _L$3;
                    }
                  }
                  if (_M0MPC14char4Char14is__whitespace(_p$9)) {
                    _p$3 = true;
                    break _L$2;
                  }
                  _tmp$3 = _p$8;
                  continue;
                } else {
                  break;
                }
              }
              _tmp$2 = false;
              break _L;
            }
            _tmp$2 = _p$3;
          }
          _tmp = _tmp$2;
        }
        if (_tmp) {
          return _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN6constrS1005;
        }
        const rule_id = _M0MPC16string10StringView9to__owned(_M0MPC16string10StringView9to__upper(trimmed));
        if (!_M0FP26Ljh68411sqlsentinel15known__rule__id(rule_id)) {
          const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(18);
          _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "unknown rule ID '");
          _M0MPB13StringBuilder13write__objectGsE(_string_builder, rule_id);
          _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, "'");
          return new _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Rejected(_string_builder.val);
        }
        if (!_M0MPC15array5Array8containsGsE(rules, rule_id)) {
          _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(rules, rule_id);
        }
        continue;
      }
    }
    return rules.length === 0 ? _M0FP26Ljh68411sqlsentinel24parse__ignore__directiveN6constrS1006 : new _M0DTP26Ljh68411sqlsentinel15ParsedDirective8Accepted(rules);
  }
}
function _M0FP26Ljh68411sqlsentinel22next__statement__index(statements, line) {
  const _bind = statements.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      let _tmp$2;
      const _p = _M0MPC15array5Array2atGRPB5ArrayGRP26Ljh68411sqlsentinel5TokenEE(statements, i);
      if (!(_p.length === 0)) {
        _tmp$2 = _M0MPC15array5Array2atGRPB4JsonE(_M0MPC15array5Array2atGRPB5ArrayGRP26Ljh68411sqlsentinel5TokenEE(statements, i), 0).line >= line;
      } else {
        _tmp$2 = false;
      }
      if (_tmp$2) {
        return i + 1 | 0;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP26Ljh68411sqlsentinel23add__directive__finding(findings, token, message) {
  _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(findings, new _M0TP26Ljh68411sqlsentinel7Finding("SQL100", "Invalid SQLSentinel directive", 1, message, "Use `-- sqlsentinel: ignore SQL003,SQL004` immediately before a SQL statement.", 0, token.line, token.column, token.text));
}
function _M0FP26Ljh68411sqlsentinel24collect__inline__ignores(tokens, statements, findings) {
  const ignores = [];
  const _bind = tokens.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const token = tokens[_];
      _L: {
        if (_M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(token.kind, 5)) {
          const _bind$2 = _M0FP26Ljh68411sqlsentinel24parse__ignore__directive(token);
          if (_bind$2.$tag === 1) {
            const _Rejected = _bind$2;
            const _message = _Rejected._0;
            _M0FP26Ljh68411sqlsentinel23add__directive__finding(findings, token, _message);
          } else {
            const _Accepted = _bind$2;
            const _rule_ids = _Accepted._0;
            const _bind$3 = _M0FP26Ljh68411sqlsentinel22next__statement__index(statements, token.line);
            if (_bind$3 === undefined) {
              _M0FP26Ljh68411sqlsentinel23add__directive__finding(findings, token, "ignore directive does not precede a SQL statement");
            } else {
              const _Some = _bind$3;
              const _statement_index = _Some;
              _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(ignores, new _M0TP26Ljh68411sqlsentinel12InlineIgnore(_statement_index, _rule_ids));
            }
          }
        } else {
          break _L;
        }
        break _L;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return ignores;
}
function _M0FP26Ljh68411sqlsentinel15inline__ignored(ignores, finding) {
  const _bind = ignores.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const ignore = ignores[_];
      if (ignore.statement_index === finding.statement_index && _M0MPC15array5Array8containsGsE(ignore.rule_ids, finding.rule_id)) {
        return true;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return false;
}
function _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, start, word) {
  let depth = 0;
  const _bind = tokens.length;
  let _tmp = start;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, i);
      if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(")) {
        depth = depth + 1 | 0;
      } else {
        if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")")) {
          if (depth > 0) {
            depth = depth - 1 | 0;
          }
        } else {
          if (depth === 0 && _M0FP26Ljh68411sqlsentinel15token__is__word(token, word)) {
            return i;
          }
        }
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP26Ljh68411sqlsentinel20main__keyword__index(tokens) {
  let depth = 0;
  let i = 0;
  while (true) {
    if (i < tokens.length) {
      const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, i);
      if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(")) {
        depth = depth + 1 | 0;
      } else {
        if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")")) {
          if (depth > 0) {
            depth = depth - 1 | 0;
          }
        } else {
          if (depth === 0 && (_M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(token.kind, 0) && (token.value === "SELECT" || (token.value === "INSERT" || (token.value === "UPDATE" || (token.value === "DELETE" || (token.value === "ALTER" || (token.value === "DROP" || (token.value === "TRUNCATE" || (token.value === "CREATE" || (token.value === "GRANT" || (token.value === "REVOKE" || token.value === "MERGE")))))))))))) {
            return i;
          }
        }
      }
      i = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return undefined;
}
function _M0FP26Ljh68411sqlsentinel21has__top__level__word(tokens, start, word) {
  const _bind = _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, start, word);
  return !(_bind === undefined);
}
function _M0FP26Ljh68411sqlsentinel14trivial__where(tokens, where_index) {
  const parts = [];
  let depth = 0;
  const _bind = where_index + 1 | 0;
  const _bind$2 = tokens.length;
  let _tmp = _bind;
  while (true) {
    const i = _tmp;
    if (i < _bind$2) {
      const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, i);
      if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(")) {
        depth = depth + 1 | 0;
      } else {
        if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")")) {
          if (depth > 0) {
            depth = depth - 1 | 0;
          }
        }
      }
      if (depth === 0 && (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "ORDER") || (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "GROUP") || (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "LIMIT") || _M0FP26Ljh68411sqlsentinel15token__is__word(token, "RETURNING"))))) {
        break;
      }
      if (depth === 0 && (!_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(") && !_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")"))) {
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(parts, token.value);
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  if (parts.length === 1) {
    const _x = parts[0];
    if (_x === "TRUE") {
      return true;
    } else {
      return false;
    }
  } else {
    if (parts.length === 3) {
      const _x = parts[0];
      switch (_x) {
        case "1": {
          const _x$2 = parts[1];
          if (_x$2 === "=") {
            const _x$3 = parts[2];
            if (_x$3 === "1") {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        }
        case "0": {
          const _x$3 = parts[1];
          if (_x$3 === "=") {
            const _x$4 = parts[2];
            if (_x$4 === "0") {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        }
        case "'<literal>'": {
          const _x$4 = parts[1];
          if (_x$4 === "=") {
            const _x$5 = parts[2];
            if (_x$5 === "'<literal>'") {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        }
        default: {
          return false;
        }
      }
    } else {
      return false;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, token_index, rule_id, title, severity, message, suggestion) {
  const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, token_index);
  _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(findings, new _M0TP26Ljh68411sqlsentinel7Finding(rule_id, title, severity, message, suggestion, statement_index, token.line, token.column, _M0FP26Ljh68411sqlsentinel19statement__evidence(tokens)));
}
function _M0FP26Ljh68411sqlsentinel31check__mutation__without__where(tokens, statement_index, findings, options) {
  const main = _M0FP26Ljh68411sqlsentinel20main__keyword__index(tokens);
  if (main === undefined) {
    return;
  } else {
    const _Some = main;
    const _index = _Some;
    const keyword = _M0MPC15array5Array2atGRPB4JsonE(tokens, _index).value;
    if (keyword === "UPDATE" || keyword === "DELETE") {
      const where_index = _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, _index + 1 | 0, "WHERE");
      _L: {
        if (where_index === undefined) {
          break _L;
        } else {
          if (where_index === undefined) {
            return;
          } else {
            const _Some$2 = where_index;
            const _w = _Some$2;
            if (_M0FP26Ljh68411sqlsentinel14trivial__where(tokens, _w)) {
              break _L;
            } else {
              return;
            }
          }
        }
      }
      const severity = options.allow_destructive ? 1 : 2;
      let message;
      if (where_index === undefined) {
        const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(56);
        _M0MPB13StringBuilder13write__objectGsE(_string_builder, keyword);
        _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " has no top-level WHERE clause and may affect every row.");
        message = _string_builder.val;
      } else {
        const _string_builder = _M0MPB13StringBuilder21StringBuilder_2einner(63);
        _M0MPB13StringBuilder13write__objectGsE(_string_builder, keyword);
        _M0IPB13StringBuilderPB6Logger13write__string(_string_builder, " uses a predicate that is always true and may affect every row.");
        message = _string_builder.val;
      }
      _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, _index, "SQL001", "Unbounded data mutation", severity, message, "Add a selective WHERE clause, or explicitly approve a full-table maintenance operation.");
      return;
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel23check__destructive__ddl(tokens, statement_index, findings, options) {
  const main = _M0FP26Ljh68411sqlsentinel20main__keyword__index(tokens);
  if (main === undefined) {
    return;
  } else {
    const _Some = main;
    const _index = _Some;
    const keyword = _M0MPC15array5Array2atGRPB4JsonE(tokens, _index).value;
    const next = (_index + 1 | 0) < tokens.length ? _M0MPC15array5Array2atGRPB4JsonE(tokens, _index + 1 | 0).value : undefined;
    let dangerous = false;
    let description = "";
    if (keyword === "TRUNCATE") {
      dangerous = true;
      const _bind = options.dialect;
      let _tmp;
      if (_bind === 3) {
        _tmp = "SQLite does not support TRUNCATE. The destructive intent is invalid in this dialect.";
      } else {
        _tmp = "TRUNCATE erases all rows from the target table.";
      }
      description = _tmp;
    } else {
      if (keyword === "DROP") {
        _L: {
          _L$2: {
            if (next === undefined) {
            } else {
              const _Some$2 = next;
              const _x = _Some$2;
              switch (_x) {
                case "TABLE": {
                  break _L$2;
                }
                case "DATABASE": {
                  break _L$2;
                }
                case "SCHEMA": {
                  break _L$2;
                }
                case "OWNED": {
                  break _L$2;
                }
              }
            }
            break _L;
          }
          dangerous = true;
          description = "The statement removes a persistent schema object.";
        }
      } else {
        if (keyword === "ALTER") {
          const drop_index = _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, _index + 1 | 0, "DROP");
          if (drop_index === undefined) {
          } else {
            const _Some$2 = drop_index;
            const _drop_pos = _Some$2;
            const afterward = [];
            const _bind = _drop_pos + 1 | 0;
            const _bind$2 = tokens.length;
            let _tmp = _bind;
            while (true) {
              const i = _tmp;
              if (i < _bind$2) {
                _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(afterward, _M0MPC15array5Array2atGRPB4JsonE(tokens, i).value);
                _tmp = i + 1 | 0;
                continue;
              } else {
                break;
              }
            }
            if (_M0MPC15array5Array8containsGsE(afterward, "COLUMN") || _M0MPC15array5Array8containsGsE(afterward, "TABLE")) {
              dangerous = true;
              description = "ALTER ... DROP removes an existing column or table object.";
            }
          }
        }
      }
    }
    if (dangerous) {
      const severity = options.allow_destructive ? 1 : 2;
      _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, _index, "SQL002", "Destructive schema change", severity, description, "Back up affected data, use expand-and-contract migration, and require explicit review.");
      return;
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel23check__wildcard__select(tokens, statement_index, findings) {
  const _bind = tokens.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      _L: {
        if (!_M0FP26Ljh68411sqlsentinel15token__is__word(_M0MPC15array5Array2atGRPB4JsonE(tokens, i), "SELECT")) {
          break _L;
        }
        let depth = 0;
        let j = i + 1 | 0;
        while (true) {
          if (j < tokens.length) {
            const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, j);
            if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(")) {
              depth = depth + 1 | 0;
            } else {
              if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")")) {
                if (depth === 0) {
                  break;
                }
                depth = depth - 1 | 0;
              } else {
                if (depth === 0 && _M0FP26Ljh68411sqlsentinel15token__is__word(token, "FROM")) {
                  break;
                } else {
                  if (depth === 0 && _M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "*")) {
                    _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, j, "SQL003", "Wildcard projection", 1, "SELECT * couples the result to every current and future column.", "List only the columns that the application actually consumes.");
                  }
                }
              }
            }
            j = j + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        break _L;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel28check__limit__without__order(tokens, statement_index, findings) {
  const main = _M0FP26Ljh68411sqlsentinel20main__keyword__index(tokens);
  if (main === undefined) {
    return;
  } else {
    const _Some = main;
    const _index = _Some;
    if (_M0MPC15array5Array2atGRPB4JsonE(tokens, _index).value === "SELECT") {
      const _bind = _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, _index + 1 | 0, "LIMIT");
      if (_bind === undefined) {
        return;
      } else {
        const _Some$2 = _bind;
        const _limit_index = _Some$2;
        if (!_M0FP26Ljh68411sqlsentinel21has__top__level__word(tokens, _index + 1 | 0, "ORDER")) {
          _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, _limit_index, "SQL004", "Non-deterministic pagination", 1, "LIMIT is present without an ORDER BY clause, so row selection is not stable.", "Add a stable ORDER BY, preferably using a unique or indexed key.");
          return;
        } else {
          return;
        }
      }
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel20check__leading__like(tokens, statement_index, findings, options) {
  const _bind = tokens.length;
  let _tmp = 0;
  while (true) {
    const i = _tmp;
    if (i < _bind) {
      _L: {
        const is_ilike = _M0FP26Ljh68411sqlsentinel15token__is__word(_M0MPC15array5Array2atGRPB4JsonE(tokens, i), "ILIKE");
        if (!(_M0FP26Ljh68411sqlsentinel15token__is__word(_M0MPC15array5Array2atGRPB4JsonE(tokens, i), "LIKE") || is_ilike)) {
          break _L;
        }
        if (is_ilike && (_M0IP016_24default__implPB2Eq10not__equalGRP26Ljh68411sqlsentinel7DialectE(options.dialect, 0) && _M0IP016_24default__implPB2Eq10not__equalGRP26Ljh68411sqlsentinel7DialectE(options.dialect, 1))) {
          break _L;
        }
        if ((i + 1 | 0) < tokens.length && _M0IP26Ljh68411sqlsentinel9TokenKindPB2Eq5equal(_M0MPC15array5Array2atGRPB4JsonE(tokens, i + 1 | 0).kind, 1)) {
          const value = _M0MPC15array5Array2atGRPB4JsonE(tokens, i + 1 | 0).value;
          const trimmed = _M0MPC16string6String11trim__start(value, undefined);
          if (_M0MPC16string10StringView11has__prefix(trimmed, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS839, 0, _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS839.length)) && !_M0MPC16string10StringView11has__prefix(trimmed, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS840, 0, _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS840.length)) || _M0MPC16string10StringView11has__prefix(trimmed, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS841, 0, _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS841.length)) && !_M0MPC16string10StringView11has__prefix(trimmed, new _M0TPC16string10StringView(_M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS842, 0, _M0FP26Ljh68411sqlsentinel20check__leading__likeN7_2abindS842.length))) {
            _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, i, "SQL005", "Leading-wildcard LIKE", 1, "The LIKE pattern starts with a wildcard and may force a broad scan.", "Prefer a prefix search or add a trigram/full-text index for contains-style matching.");
          }
        }
        break _L;
      }
      _tmp = i + 1 | 0;
      continue;
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel18check__comma__join(tokens, statement_index, findings) {
  const main = _M0FP26Ljh68411sqlsentinel20main__keyword__index(tokens);
  if (main === undefined) {
    return;
  } else {
    const _Some = main;
    const _index = _Some;
    if (_M0MPC15array5Array2atGRPB4JsonE(tokens, _index).value === "SELECT") {
      const _bind = _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, _index + 1 | 0, "FROM");
      if (_bind === undefined) {
        return;
      } else {
        const _Some$2 = _bind;
        const _from_index = _Some$2;
        let depth = 0;
        let has_join = false;
        let comma_index = undefined;
        let j = _from_index + 1 | 0;
        while (true) {
          if (j < tokens.length) {
            const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, j);
            if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(")) {
              depth = depth + 1 | 0;
            } else {
              if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")")) {
                if (depth > 0) {
                  depth = depth - 1 | 0;
                }
              } else {
                if (depth === 0 && (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "WHERE") || (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "GROUP") || (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "ORDER") || (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "LIMIT") || _M0FP26Ljh68411sqlsentinel15token__is__word(token, "RETURNING")))))) {
                  break;
                } else {
                  if (depth === 0 && _M0FP26Ljh68411sqlsentinel15token__is__word(token, "JOIN")) {
                    has_join = true;
                  } else {
                    if (depth === 0) {
                      if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ",")) {
                        const _bind$2 = comma_index;
                        if (_bind$2 === undefined) {
                          comma_index = j;
                        }
                      }
                    }
                  }
                }
              }
            }
            j = j + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        if (!has_join) {
          const _bind$2 = comma_index;
          if (_bind$2 === undefined) {
            return;
          } else {
            const _Some$3 = _bind$2;
            const _comma = _Some$3;
            _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, _comma, "SQL006", "Comma join", 1, "The FROM clause uses a comma-separated table list without an explicit JOIN.", "Use explicit JOIN syntax and place relationship predicates in ON.");
            return;
          }
        } else {
          return;
        }
      }
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel22check__insert__columns(tokens, statement_index, findings) {
  const main = _M0FP26Ljh68411sqlsentinel20main__keyword__index(tokens);
  if (main === undefined) {
    return;
  } else {
    const _Some = main;
    const _index = _Some;
    if (_M0MPC15array5Array2atGRPB4JsonE(tokens, _index).value === "INSERT") {
      const _bind = _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, _index + 1 | 0, "INTO");
      if (_bind === undefined) {
        return;
      } else {
        const _Some$2 = _bind;
        const _into_index = _Some$2;
        let depth = 0;
        let saw_column_list = false;
        let saw_values = undefined;
        let saw_default = false;
        let j = _into_index + 1 | 0;
        while (true) {
          if (j < tokens.length) {
            const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, j);
            if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(")) {
              if (depth === 0) {
                saw_column_list = true;
              }
              depth = depth + 1 | 0;
            } else {
              if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")")) {
                if (depth > 0) {
                  depth = depth - 1 | 0;
                }
              } else {
                if (depth === 0 && _M0FP26Ljh68411sqlsentinel15token__is__word(token, "DEFAULT")) {
                  saw_default = true;
                } else {
                  if (depth === 0 && (_M0FP26Ljh68411sqlsentinel15token__is__word(token, "VALUES") || _M0FP26Ljh68411sqlsentinel15token__is__word(token, "SELECT"))) {
                    saw_values = j;
                    break;
                  }
                }
              }
            }
            j = j + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        const _bind$2 = saw_values;
        if (_bind$2 === undefined) {
          return;
        } else {
          const _Some$3 = _bind$2;
          const _values_index = _Some$3;
          if (!saw_column_list && !saw_default) {
            _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, _values_index, "SQL007", "INSERT without a column list", 1, "The INSERT relies on physical column order and will break when the table shape changes.", "Name every target column explicitly in the INSERT statement.");
            return;
          } else {
            return;
          }
        }
      }
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel21check__add__not__null(tokens, statement_index, findings, options) {
  const main = _M0FP26Ljh68411sqlsentinel20main__keyword__index(tokens);
  if (main === undefined) {
    return;
  } else {
    const _Some = main;
    const _index = _Some;
    if (_M0MPC15array5Array2atGRPB4JsonE(tokens, _index).value === "ALTER") {
      const add_index = _M0FP26Ljh68411sqlsentinel16top__level__word(tokens, _index + 1 | 0, "ADD");
      if (add_index === undefined) {
        return;
      } else {
        const _Some$2 = add_index;
        const _add_pos = _Some$2;
        let has_not_null = false;
        let has_default = false;
        let depth = 0;
        const _bind = _add_pos + 1 | 0;
        const _bind$2 = tokens.length;
        let _tmp = _bind;
        while (true) {
          const i = _tmp;
          if (i < _bind$2) {
            const token = _M0MPC15array5Array2atGRPB4JsonE(tokens, i);
            if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, "(")) {
              depth = depth + 1 | 0;
            } else {
              if (_M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ")")) {
                if (depth > 0) {
                  depth = depth - 1 | 0;
                }
              } else {
                if (depth === 0 && _M0FP26Ljh68411sqlsentinel17token__is__symbol(token, ",")) {
                  break;
                } else {
                  if (depth === 0 && _M0FP26Ljh68411sqlsentinel15token__is__word(token, "DEFAULT")) {
                    has_default = true;
                  } else {
                    if (depth === 0 && _M0FP26Ljh68411sqlsentinel15token__is__word(token, "NOT")) {
                      if ((i + 1 | 0) < tokens.length && _M0FP26Ljh68411sqlsentinel15token__is__word(_M0MPC15array5Array2atGRPB4JsonE(tokens, i + 1 | 0), "NULL")) {
                        has_not_null = true;
                      }
                    }
                  }
                }
              }
            }
            _tmp = i + 1 | 0;
            continue;
          } else {
            break;
          }
        }
        if (has_not_null && !has_default) {
          const severity = _M0IP26Ljh68411sqlsentinel7DialectPB2Eq5equal(options.dialect, 3) ? 2 : 1;
          const message = _M0IP26Ljh68411sqlsentinel7DialectPB2Eq5equal(options.dialect, 3) ? "SQLite rejects adding a NOT NULL column without a default." : "Adding a NOT NULL column without a default can fail existing rows or force a table rewrite.";
          _M0FP26Ljh68411sqlsentinel12add__finding(findings, tokens, statement_index, _add_pos, "SQL008", "NOT NULL column without a default", severity, message, "Add a nullable/defaulted column, backfill it, then enforce NOT NULL in a later migration.");
          return;
        } else {
          return;
        }
      }
    } else {
      return;
    }
  }
}
function _M0FP26Ljh68411sqlsentinel17compare__findings(a, b) {
  return a.line < b.line ? -1 : a.line > b.line ? 1 : a.column < b.column ? -1 : a.column > b.column ? 1 : _M0MP26Ljh68411sqlsentinel8Severity4rank(a.severity) > _M0MP26Ljh68411sqlsentinel8Severity4rank(b.severity) ? -1 : _M0MP26Ljh68411sqlsentinel8Severity4rank(a.severity) < _M0MP26Ljh68411sqlsentinel8Severity4rank(b.severity) ? 1 : _M0IPC16string6StringPB7Compare7compare(a.rule_id, b.rule_id);
}
function _M0FP26Ljh68411sqlsentinel15count__findings(findings, severity) {
  let count = 0;
  const _bind = findings.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const finding = findings[_];
      if (_M0IP26Ljh68411sqlsentinel8SeverityPB2Eq5equal(finding.severity, severity)) {
        count = count + 1 | 0;
      }
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return count;
}
function _M0FP26Ljh68411sqlsentinel23summarize__suppressions(findings) {
  const _bind = [];
  const counts = _M0MPB3Map3MapGsiE(new _M0TPB9ArrayViewGUsiEE(_bind, 0, 0), undefined);
  const _bind$2 = findings.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind$2) {
      const finding = findings[_];
      _M0MPB3Map19update__or__defaultGsiE(counts, finding.rule_id, 1, (count) => count + 1 | 0);
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const summary = [];
  const _it = _M0MPB3Map5iter2GsiE(counts);
  while (true) {
    const _bind$3 = _M0MPB5Iter24nextGsiE(_it);
    if (_bind$3 === undefined) {
      break;
    } else {
      const _Some = _bind$3;
      const _x = _Some;
      const _rule_id = _x._0;
      const _count = _x._1;
      _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(summary, new _M0TP26Ljh68411sqlsentinel14SuppressedRule(_rule_id, _count));
      continue;
    }
  }
  _M0MPC15array5Array8sort__byGRP26Ljh68411sqlsentinel7FindingE(summary, (a, b) => _M0IPC16string6StringPB7Compare7compare(a.rule_id, b.rule_id));
  return summary;
}
function _M0FP26Ljh68411sqlsentinel24scan__sql__with__options(source, options) {
  const tokens = _M0FP26Ljh68411sqlsentinel8tokenize(source);
  const statements = _M0FP26Ljh68411sqlsentinel17split__statements(tokens);
  const findings = [];
  const inline_ignores = _M0FP26Ljh68411sqlsentinel24collect__inline__ignores(tokens, statements, findings);
  let index = 0;
  const _bind = statements.length;
  let _tmp = 0;
  while (true) {
    const _ = _tmp;
    if (_ < _bind) {
      const tokens$2 = statements[_];
      const statement_index = index + 1 | 0;
      _M0FP26Ljh68411sqlsentinel31check__mutation__without__where(tokens$2, statement_index, findings, options);
      _M0FP26Ljh68411sqlsentinel23check__destructive__ddl(tokens$2, statement_index, findings, options);
      if (options.style_checks) {
        _M0FP26Ljh68411sqlsentinel23check__wildcard__select(tokens$2, statement_index, findings);
        _M0FP26Ljh68411sqlsentinel28check__limit__without__order(tokens$2, statement_index, findings);
        _M0FP26Ljh68411sqlsentinel20check__leading__like(tokens$2, statement_index, findings, options);
        _M0FP26Ljh68411sqlsentinel18check__comma__join(tokens$2, statement_index, findings);
        _M0FP26Ljh68411sqlsentinel22check__insert__columns(tokens$2, statement_index, findings);
        _M0FP26Ljh68411sqlsentinel21check__add__not__null(tokens$2, statement_index, findings, options);
      }
      index = index + 1 | 0;
      _tmp = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  _M0MPC15array5Array8sort__byGRP26Ljh68411sqlsentinel7FindingE(findings, _M0FP26Ljh68411sqlsentinel17compare__findings);
  const _p = [];
  const _p$2 = findings.length;
  let _tmp$2 = 0;
  while (true) {
    const _p$3 = _tmp$2;
    if (_p$3 < _p$2) {
      const _p$4 = findings[_p$3];
      if (!_M0FP26Ljh68411sqlsentinel15inline__ignored(inline_ignores, _p$4)) {
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(_p, _p$4);
      }
      _tmp$2 = _p$3 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const after_inline = _p;
  const _p$3 = [];
  const _p$4 = findings.length;
  let _tmp$3 = 0;
  while (true) {
    const _p$5 = _tmp$3;
    if (_p$5 < _p$4) {
      const _p$6 = findings[_p$5];
      if (_M0FP26Ljh68411sqlsentinel15inline__ignored(inline_ignores, _p$6)) {
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(_p$3, _p$6);
      }
      _tmp$3 = _p$5 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const suppressed_inline = _p$3;
  const _p$5 = [];
  const _p$6 = after_inline.length;
  let _tmp$4 = 0;
  while (true) {
    const _p$7 = _tmp$4;
    if (_p$7 < _p$6) {
      const _p$8 = after_inline[_p$7];
      if (!_M0MPC15array5Array8containsGsE(options.ignored_rules, _p$8.rule_id)) {
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(_p$5, _p$8);
      }
      _tmp$4 = _p$7 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const active_findings = _p$5;
  const _p$7 = [];
  const _p$8 = after_inline.length;
  let _tmp$5 = 0;
  while (true) {
    const _p$9 = _tmp$5;
    if (_p$9 < _p$8) {
      const _p$10 = after_inline[_p$9];
      if (_M0MPC15array5Array8containsGsE(options.ignored_rules, _p$10.rule_id)) {
        _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(_p$7, _p$10);
      }
      _tmp$5 = _p$9 + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const suppressed_globally = _p$7;
  const suppressed = [];
  const _bind$2 = suppressed_inline.length;
  let _tmp$6 = 0;
  while (true) {
    const _ = _tmp$6;
    if (_ < _bind$2) {
      const finding = suppressed_inline[_];
      _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(suppressed, finding);
      _tmp$6 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  const _bind$3 = suppressed_globally.length;
  let _tmp$7 = 0;
  while (true) {
    const _ = _tmp$7;
    if (_ < _bind$3) {
      const finding = suppressed_globally[_];
      _M0MPC15array5Array4pushGRP26Ljh68411sqlsentinel7FindingE(suppressed, finding);
      _tmp$7 = _ + 1 | 0;
      continue;
    } else {
      break;
    }
  }
  return new _M0TP26Ljh68411sqlsentinel6Report(index, active_findings, _M0FP26Ljh68411sqlsentinel15count__findings(active_findings, 2), _M0FP26Ljh68411sqlsentinel15count__findings(active_findings, 1), _M0FP26Ljh68411sqlsentinel15count__findings(active_findings, 0), suppressed.length, _M0FP26Ljh68411sqlsentinel23summarize__suppressions(suppressed), options.dialect);
}
function _M0FP26Ljh68411sqlsentinel15scan__sql__with(source, options) {
  return _M0FP26Ljh68411sqlsentinel24scan__sql__with__options(source, options);
}
function _M0FP36Ljh68411sqlsentinel3web12web__options(dialect_name) {
  const _bind = _M0MP26Ljh68411sqlsentinel7Dialect5parse(dialect_name);
  let dialect;
  if (_bind === undefined) {
    dialect = 0;
  } else {
    const _Some = _bind;
    dialect = _Some;
  }
  return _M0MP26Ljh68411sqlsentinel11ScanOptions3new(-1, -1, _M0DTPC16option6OptionGRPB5ArrayGsEE4None__, dialect);
}
function _M0FP36Ljh68411sqlsentinel3web15scan__sql__json(sql, dialect_name) {
  const report = _M0FP26Ljh68411sqlsentinel15scan__sql__with(sql, _M0FP36Ljh68411sqlsentinel3web12web__options(dialect_name));
  return _M0FP26Ljh68411sqlsentinel16report__to__json(report);
}
function _M0FP36Ljh68411sqlsentinel3web19scan__sql__markdown(sql, dialect_name) {
  const report = _M0FP26Ljh68411sqlsentinel15scan__sql__with(sql, _M0FP36Ljh68411sqlsentinel3web12web__options(dialect_name));
  return _M0FP26Ljh68411sqlsentinel28report__to__markdown_2einner(report, "playground.sql");
}
export { _M0FP36Ljh68411sqlsentinel3web15scan__sql__json as scanSqlJson, _M0FP36Ljh68411sqlsentinel3web19scan__sql__markdown as scanSqlMarkdown }
