/*
* Validation v1.3.2
*/


(function() {
  'use strict';
  var $, ALPHANUMERIC_CHARS_WITH_SIGN, ALPHA_CHARS, CustomRule, DEBUG_MODE, DIGIT_CHARS, FULLWIDTH_ALPHANUMERIC_CHARS_WITH_SIGN, FULLWIDTH_ALPHA_CHARS, FULLWIDTH_DIGIT_CHARS, FULLWIDTH_SING_CHARS, HIRAGANA_CHARS, JAPANESE_SIGN_CHARS, KANA_COMMON_CAHRS, KATAKANA_CHARS, NARROW_JAPANESE_SIGN_CHARS, NARROW_KATAKANA_CHARS, Rule, RuleGroup, RuleMaster, SIGN_CHARS, SPACE_LIKE_CHARS, VString, Validation, checkGengo, log, w, w2s, warn,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  w = this;

  $ = this.jQuery;

  DEBUG_MODE = true;

  SIGN_CHARS = '\\u0020-\\u002F\\u003A-\\u0041\\u005B-\\u0061\\u007B-\\u007E';

  DIGIT_CHARS = '0-9';

  ALPHA_CHARS = 'A-Za-z';

  ALPHANUMERIC_CHARS_WITH_SIGN = '\\u0020-\\u007E';

  FULLWIDTH_SING_CHARS = '\\uFF01-\\uFF0F\\uFF1A-\\uFF20\\uFF3B-\\uFF40\\uFF5B-\\uFF5E';

  FULLWIDTH_DIGIT_CHARS = '\\uFF10-\\uFF19';

  FULLWIDTH_ALPHA_CHARS = '\\uFF21-\\uFF3A\\uFF41-\\uFF5A';

  FULLWIDTH_ALPHANUMERIC_CHARS_WITH_SIGN = '\\uFF01-\\uFF5F';

  HIRAGANA_CHARS = '\\u3041-\\u3096\\u309D-\\u309F';

  KATAKANA_CHARS = '\\u30A1-\\u30FA\\u30FD\\u30FF';

  KANA_COMMON_CAHRS = '\u3099-\u309C\u30FC';

  JAPANESE_SIGN_CHARS = '\u3000-\u3036\u30FB\\uFF5E';

  NARROW_KATAKANA_CHARS = '\\uFF66-\\uFF9F';

  NARROW_JAPANESE_SIGN_CHARS = '\\uFF61-\\uFF65';

  SPACE_LIKE_CHARS = '\\s\\n\\t\\u0009\\u0020\\u00A0\\u2002-\\u200B\\u3000\\uFEFF';

  w2s = function(year, gengo) {
    var gengos;
    gengos = {
      '明治': 1868,
      '大正': 1912,
      '昭和': 1926,
      '平成': 1989
    };
    return gengos[gengo] + year - 1;
  };

  checkGengo = function(gengo, year, month, date) {
    var end, gengos, start;
    gengos = {
      '明治': [9, 8, 45, 7, 29],
      '大正': [7, 30, 15, 12, 24],
      '昭和': [12, 25, 64, 1, 7],
      '平成': [1, 8, Infinity, Infinity, Infinity]
    };
    start = {
      month: gengos[gengo][0],
      date: gengos[gengo][1]
    };
    end = {
      year: gengos[gengo][2],
      month: gengos[gengo][3],
      date: gengos[gengo][4]
    };
    if (isNaN(month)) {
      if (end.year < year) {
        return {
          end: end
        };
      }
    } else if (isNaN(date)) {
      if (end.year < year || (end.year === year && end.month < month)) {
        return {
          end: end
        };
      } else if (1 === year && start.month > month) {
        return {
          start: start
        };
      }
    } else {
      if (end.year < year || (end.year === year && end.month < month) || (end.year === year && end.month === month && end.date < date)) {
        return {
          end: end
        };
      } else if ((1 === year && start.month > month) || (1 === year && start.month === month && start.date > date)) {
        return {
          start: start
        };
      }
    }
    return null;
  };

  VString = (function(_super) {
    var _rIncluded;

    __extends(VString, _super);

    _rIncluded = function(chars) {
      return new RegExp("[" + (chars.join('')) + "]", 'g');
    };

    VString.SIGN = 1 << 1;

    VString.DIGIT = 1 << 2;

    VString.ALPHABET = 1 << 3;

    VString.HIRAGANA = 1 << 4;

    VString.KATAKANA = 1 << 5;

    VString.FULLWIDTH_SIGN = 1 << 6;

    VString.FULLWIDTH_DIGIT = 1 << 7;

    VString.FULLWIDTH_ALPHABET = 1 << 8;

    VString.JAPANESE_SIGN = 1 << 9;

    VString.NARROW_KATAKANA = 1 << 10;

    VString.NARROW_JAPANESE_SIGN = 1 << 11;

    VString.ALPHANUMERIC = VString.DIGIT | VString.ALPHABET;

    VString.FULLWIDTH_ALPHANUMERIC = VString.FULLWIDTH_DIGIT | VString.FULLWIDTH_ALPHABET;

    VString.KANA = VString.HIRAGANA | VString.KATAKANA;

    VString.KANA_WITH_SIGN = VString.KANA | VString.JAPANESE_SIGN;

    VString.NARROW_JAPANESE = VString.NARROW_KATAKANA | VString.NARROW_JAPANESE_SIGN;

    VString.ANK = VString.ALPHANUMERIC | VString.NARROW_JAPANESE;

    VString.patterns = {
      SIGN_CHARS: SIGN_CHARS,
      DIGIT_CHARS: DIGIT_CHARS,
      ALPHA_CHARS: ALPHA_CHARS,
      ALPHANUMERIC_CHARS_WITH_SIGN: ALPHANUMERIC_CHARS_WITH_SIGN,
      FULLWIDTH_SING_CHARS: FULLWIDTH_SING_CHARS,
      FULLWIDTH_DIGIT_CHARS: FULLWIDTH_DIGIT_CHARS,
      FULLWIDTH_ALPHA_CHARS: FULLWIDTH_ALPHA_CHARS,
      FULLWIDTH_ALPHANUMERIC_CHARS_WITH_SIGN: FULLWIDTH_ALPHANUMERIC_CHARS_WITH_SIGN,
      HIRAGANA_CHARS: HIRAGANA_CHARS,
      KATAKANA_CHARS: KATAKANA_CHARS,
      KANA_COMMON_CAHRS: KANA_COMMON_CAHRS,
      JAPANESE_SIGN_CHARS: JAPANESE_SIGN_CHARS,
      NARROW_KATAKANA_CHARS: NARROW_KATAKANA_CHARS,
      NARROW_JAPANESE_SIGN_CHARS: NARROW_JAPANESE_SIGN_CHARS,
      SPACE_LIKE_CHARS: SPACE_LIKE_CHARS
    };

    VString.prototype._ = '';

    function VString(str) {
      if (str == null) {
        str = '';
      }
      this._ = str + '';
    }

    VString.prototype.toString = function() {
      return this._;
    };

    VString.prototype.valueOf = function() {
      return this.toString();
    };

    VString.prototype.concat = function() {
      var strs;
      strs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return this.string(VString.__super__.concat.call(this, strs.join('')));
    };

    VString.prototype.replace = function(pattern, replacement) {
      var char, newChar, res;
      res = this.clone();
      if ($.isPlainObject(pattern)) {
        for (char in pattern) {
          newChar = pattern[char];
          res = res.replace(new RegExp(char, 'g'), newChar);
        }
      } else {
        res = new this.constructor(VString.__super__.replace.call(this, pattern, replacement));
      }
      this.string(res);
      return res;
    };

    VString.prototype.slice = function(from, to) {
      return this.string(VString.__super__.slice.call(this, from, to));
    };

    VString.prototype.substr = function(from, length) {
      return this.string(VString.__super__.substr.call(this, form, length));
    };

    VString.prototype.substring = function(from, to) {
      return this.string(VString.__super__.substring.call(this, from, to));
    };

    VString.prototype.toLowerCase = function() {
      return this.string(VString.__super__.toLowerCase.call(this));
    };

    VString.prototype.toUpperCase = function() {
      return this.string(VString.__super__.toUpperCase.call(this));
    };

    VString.prototype.trim = function() {
      return this.remove(new RegExp("^[" + SPACE_LIKE_CHARS + "]+|[" + SPACE_LIKE_CHARS + "]+$", 'g'));
    };

    VString.prototype.string = function(str) {
      if (str == null) {
        str = '';
      }
      return new this.constructor(this._ = str + '');
    };

    VString.prototype.getLength = function() {
      return this._.length;
    };

    VString.prototype.empty = function() {
      return !this._;
    };

    VString.prototype.clone = function() {
      return new this.constructor(this._);
    };

    VString.prototype.remove = function(pattern) {
      return this.replace(pattern, '');
    };

    VString.prototype.test = function(pattern) {
      if (!(pattern instanceof RegExp)) {
        pattern = new RegExp(pattern);
      }
      return pattern.test(this);
    };

    VString.prototype.add = function(str) {
      if (str == null) {
        str = '';
      }
      return this.string(str + this._);
    };

    VString.prototype.is = function(str) {
      return this._ === String(str);
    };

    VString.prototype.replaceEach = function(callback) {
      var _this;
      if (!$.isFunction(callback)) {
        return this;
      }
      _this = this;
      return this.replace(/./g, function(str) {
        var res;
        res = callback.call(_this, str);
        return String(res != null ? res : matches[0]);
      });
    };

    VString.prototype.change = function(replacement) {
      var res;
      res = $.isFunction(replacement) ? replacement(this) : replacement;
      return this.string(res);
    };

    VString.prototype.isOnly = function() {
      var chars, flag, rChars, withSpace;
      chars = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      flag = chars[0];
      withSpace = chars[chars.length - 1];
      if (flag - 0 === flag) {
        chars = [];
        if ((flag & VString.SIGN) !== 0) {
          chars.push(SIGN_CHARS);
        }
        if ((flag & VString.DIGIT) !== 0) {
          chars.push(DIGIT_CHARS);
        }
        if ((flag & VString.ALPHABET) !== 0) {
          chars.push(ALPHA_CHARS);
        }
        if ((flag & VString.HIRAGANA) !== 0) {
          chars.push(HIRAGANA_CHARS + KANA_COMMON_CAHRS);
        }
        if ((flag & VString.KATAKANA) !== 0) {
          chars.push(KATAKANA_CHARS + KANA_COMMON_CAHRS);
        }
        if ((flag & VString.FULLWIDTH_SIGN) !== 0) {
          chars.push(FULLWIDTH_SING_CHARS);
        }
        if ((flag & VString.FULLWIDTH_DIGIT) !== 0) {
          chars.push(FULLWIDTH_DIGIT_CHARS);
        }
        if ((flag & VString.FULLWIDTH_ALPHABET) !== 0) {
          chars.push(FULLWIDTH_ALPHA_CHARS);
        }
        if ((flag & VString.JAPANESE_SIGN) !== 0) {
          chars.push(JAPANESE_SIGN_CHARS);
        }
        if ((flag & VString.NARROW_KATAKANA) !== 0) {
          chars.push(NARROW_KATAKANA_CHARS);
        }
        if ((flag & VString.NARROW_JAPANESE_SIGN) !== 0) {
          chars.push(NARROW_JAPANESE_SIGN_CHARS);
        }
      }
      if (withSpace === !!withSpace) {
        chars.push(SPACE_LIKE_CHARS);
      }
      rChars = new RegExp("^[" + (chars.join('')) + "]+$", 'g');
      return rChars.test(this);
    };

    VString.prototype.shift = function(n) {
      var chars, res, shift;
      res = this.clone();
      if (isFinite(n)) {
        res = res.replaceEach(function(char) {
          return String.fromCharCode(char.charCodeAt(0) + parseInt(n, 10));
        });
      } else if ($.isPlainObject(n)) {
        for (chars in n) {
          shift = n[chars];
          res = res.replace(_rIncluded([chars]), function(char) {
            return String.fromCharCode(char.charCodeAt(0) + parseInt(shift, 10));
          });
        }
      } else {
        throw new Error('Invalid arguments');
      }
      this.string(res);
      return res;
    };

    VString.prototype.combinate = function() {
      return this.replace({
        '\u309B': '\u3099',
        '\u309C': '\u309A'
      });
    };

    VString.prototype.toHiragana = function(combinate) {
      var hash, res;
      if (combinate == null) {
        combinate = false;
      }
      hash = {};
      hash[KATAKANA_CHARS] = -96;
      res = this.toWideKatakana().replace({
        'ヷ': 'わ゛',
        'ヸ': 'ゐ゛',
        'ヹ': 'ゑ゛',
        'ヺ': 'を゛'
      }).shift(hash);
      if (combinate) {
        return res.combinate();
      } else {
        return res;
      }
    };

    VString.prototype.toKatakana = function() {
      var hash;
      hash = {};
      hash[HIRAGANA_CHARS] = +96;
      return this.toWideKatakana().replace(/\u308F(?:\u309B|\u3099|\uFF9E)/g, '\u30F7').replace(/\u3090(?:\u309B|\u3099|\uFF9E)/g, '\u30F8').replace(/\u3091(?:\u309B|\u3099|\uFF9E)/g, '\u30F9').replace(/\u3092(?:\u309B|\u3099|\uFF9E)/g, '\u30FA').shift(hash);
    };

    VString.prototype.toNarrowKatakana = function() {
      return this.replace(/\u309B|\u3099/g, '\uFF9E').replace(/\u309C|\u309A/g, '\uFF9F').replace({
        'ァ': 'ｧ',
        'ィ': 'ｨ',
        'ゥ': 'ｩ',
        'ェ': 'ｪ',
        'ォ': 'ｫ',
        'ャ': 'ｬ',
        'ュ': 'ｭ',
        'ョ': 'ｮ',
        'ッ': 'ｯ',
        'ー': 'ｰ',
        'ア': 'ｱ',
        'イ': 'ｲ',
        'ウ': 'ｳ',
        'エ': 'ｴ',
        'オ': 'ｵ',
        'カ': 'ｶ',
        'キ': 'ｷ',
        'ク': 'ｸ',
        'ケ': 'ｹ',
        'コ': 'ｺ',
        'サ': 'ｻ',
        'シ': 'ｼ',
        'ス': 'ｽ',
        'セ': 'ｾ',
        'ソ': 'ｿ',
        'タ': 'ﾀ',
        'チ': 'ﾁ',
        'ツ': 'ﾂ',
        'テ': 'ﾃ',
        'ト': 'ﾄ',
        'ナ': 'ﾅ',
        'ニ': 'ﾆ',
        'ヌ': 'ﾇ',
        'ネ': 'ﾈ',
        'ノ': 'ﾉ',
        'ハ': 'ﾊ',
        'ヒ': 'ﾋ',
        'フ': 'ﾌ',
        'ヘ': 'ﾍ',
        'ホ': 'ﾎ',
        'マ': 'ﾏ',
        'ミ': 'ﾐ',
        'ム': 'ﾑ',
        'メ': 'ﾒ',
        'モ': 'ﾓ',
        'ヤ': 'ﾔ',
        'ユ': 'ﾕ',
        'ヨ': 'ﾖ',
        'ラ': 'ﾗ',
        'リ': 'ﾘ',
        'ル': 'ﾙ',
        'レ': 'ﾚ',
        'ロ': 'ﾛ',
        'ワ': 'ﾜ',
        'ン': 'ﾝ',
        'ヰ': 'ｲ',
        'ヱ': 'ｴ',
        'ヲ': 'ｦ',
        'ガ': 'ｶﾞ',
        'ギ': 'ｷﾞ',
        'グ': 'ｸﾞ',
        'ゲ': 'ｹﾞ',
        'ゴ': 'ｺﾞ',
        'ザ': 'ｻﾞ',
        'ジ': 'ｼﾞ',
        'ズ': 'ｽﾞ',
        'ゼ': 'ｾﾞ',
        'ゾ': 'ｿﾞ',
        'ダ': 'ﾀﾞ',
        'ヂ': 'ﾁﾞ',
        'ヅ': 'ﾂﾞ',
        'デ': 'ﾃﾞ',
        'ド': 'ﾄﾞ',
        'バ': 'ﾊﾞ',
        'ビ': 'ﾋﾞ',
        'ブ': 'ﾌﾞ',
        'ベ': 'ﾍﾞ',
        'ボ': 'ﾎﾞ',
        'パ': 'ﾊﾟ',
        'ピ': 'ﾋﾟ',
        'プ': 'ﾌﾟ',
        'ペ': 'ﾍﾟ',
        'ポ': 'ﾎﾟ',
        'ヷ': 'ﾜﾞ',
        'ヸ': 'ｲﾞ',
        'ヹ': 'ｴﾞ',
        'ヺ': 'ｦﾞ'
      });
    };

    VString.prototype.toWideKatakana = function() {
      return this.replace({
        'ｶﾞ': 'ガ',
        'ｷﾞ': 'ギ',
        'ｸﾞ': 'グ',
        'ｹﾞ': 'ゲ',
        'ｺﾞ': 'ゴ',
        'ｻﾞ': 'ザ',
        'ｼﾞ': 'ジ',
        'ｽﾞ': 'ズ',
        'ｾﾞ': 'ゼ',
        'ｿﾞ': 'ゾ',
        'ﾀﾞ': 'ダ',
        'ﾁﾞ': 'ヂ',
        'ﾂﾞ': 'ヅ',
        'ﾃﾞ': 'デ',
        'ﾄﾞ': 'ド',
        'ﾊﾞ': 'バ',
        'ﾋﾞ': 'ビ',
        'ﾌﾞ': 'ブ',
        'ﾍﾞ': 'ベ',
        'ﾎﾞ': 'ボ',
        'ﾊﾟ': 'パ',
        'ﾋﾟ': 'ピ',
        'ﾌﾟ': 'プ',
        'ﾍﾟ': 'ペ',
        'ﾎﾟ': 'ポ',
        'ﾜﾞ': 'ヷ',
        'ｲﾞ': 'ヸ',
        'ｳﾞ': 'ヴ',
        'ｴﾞ': 'ヹ',
        'ｦﾞ': 'ヺ',
        'ﾞ': '゛',
        'ﾟ': '゜',
        'ｧ': 'ァ',
        'ｨ': 'ィ',
        'ｩ': 'ゥ',
        'ｪ': 'ェ',
        'ｫ': 'ォ',
        'ｬ': 'ャ',
        'ｭ': 'ュ',
        'ｮ': 'ョ',
        'ｯ': 'ッ',
        'ｰ': 'ー',
        'ｱ': 'ア',
        'ｲ': 'イ',
        'ｳ': 'ウ',
        'ｴ': 'エ',
        'ｵ': 'オ',
        'ｶ': 'カ',
        'ｷ': 'キ',
        'ｸ': 'ク',
        'ｹ': 'ケ',
        'ｺ': 'コ',
        'ｻ': 'サ',
        'ｼ': 'シ',
        'ｽ': 'ス',
        'ｾ': 'セ',
        'ｿ': 'ソ',
        'ﾀ': 'タ',
        'ﾁ': 'チ',
        'ﾂ': 'ツ',
        'ﾃ': 'テ',
        'ﾄ': 'ト',
        'ﾅ': 'ナ',
        'ﾆ': 'ニ',
        'ﾇ': 'ヌ',
        'ﾈ': 'ネ',
        'ﾉ': 'ノ',
        'ﾊ': 'ハ',
        'ﾋ': 'ヒ',
        'ﾌ': 'フ',
        'ﾍ': 'ヘ',
        'ﾎ': 'ホ',
        'ﾏ': 'マ',
        'ﾐ': 'ミ',
        'ﾑ': 'ム',
        'ﾒ': 'メ',
        'ﾓ': 'モ',
        'ﾔ': 'ヤ',
        'ﾕ': 'ユ',
        'ﾖ': 'ヨ',
        'ﾗ': 'ラ',
        'ﾘ': 'リ',
        'ﾙ': 'ル',
        'ﾚ': 'レ',
        'ﾛ': 'ロ',
        'ﾜ': 'ワ',
        'ﾝ': 'ン',
        'ｦ': 'ヲ'
      });
    };

    VString.prototype.toNarrowJapneseSymbol = function() {
      return this.replace({
        '。': '｡',
        '「': '｢',
        '」': '｣',
        '、': '､',
        '・': '･'
      });
    };

    VString.prototype.toWideJapneseSymbol = function() {
      return this.replace({
        '｡': '。',
        '｢': '「',
        '｣': '」',
        '､': '、',
        '･': '・'
      });
    };

    VString.prototype.toNarrowJapnese = function() {
      return this.toNarrowKatakana().toNarrowJapneseSymbol();
    };

    VString.prototype.toWideJapnese = function() {
      return this.toWideKatakana().toWideJapneseSymbol();
    };

    VString.prototype.toNarrow = function(japaneseChars) {
      var hash, res;
      if (japaneseChars == null) {
        japaneseChars = false;
      }
      res = this.replace(_rIncluded([SPACE_LIKE_CHARS]), ' ');
      hash = {};
      hash[FULLWIDTH_ALPHANUMERIC_CHARS_WITH_SIGN] = -65248;
      res = res.shift(hash);
      if (japaneseChars) {
        res = res.toNarrowJapnese();
      }
      return res;
    };

    VString.prototype.toWide = function() {
      var hash, res;
      res = this.replace(/\s/g, '\u3000');
      hash = {};
      hash[ALPHANUMERIC_CHARS_WITH_SIGN] = +65248;
      return this.toWideJapnese().shift(hash);
    };

    VString.prototype.toNumber = function() {
      return parseFloat(this.toNarrow().remove(','));
    };

    VString.prototype.toCode = function(digit, inAlpha, inHyphen) {
      var char, res;
      char = DIGIT_CHARS;
      if (inAlpha) {
        char += ALPHA_CHARS;
      }
      if (inHyphen) {
        char += '-';
      }
      res = this.toNarrow().remove(new RegExp("[^" + char + "]", 'g'));
      if (digit) {
        while (res.getLength() < digit) {
          res = res.add(0);
        }
      }
      return res;
    };

    VString.prototype.toBool = function() {
      return !!this._;
    };

    VString.prototype.toArray = function() {
      return this._.split('');
    };

    VString.prototype.toCharCodeArray = function() {
      var char, chars, i, _i, _len;
      chars = this.toArray();
      for (i = _i = 0, _len = chars.length; _i < _len; i = ++_i) {
        char = chars[i];
        chars[i] = '\\u' + char.charCodeAt(0).toString(16);
      }
      return chars;
    };

    VString.prototype.toCharCode = function() {
      return this.toCharCodeArray.join('');
    };

    VString.prototype.isOnlyHiragana = function(withSpace) {
      return this.isOnly(HIRAGANA_CHARS, KANA_COMMON_CAHRS, withSpace ? SPACE_LIKE_CHARS : '');
    };

    VString.prototype.isOnlyKatakana = function(withSpace) {
      return this.isOnly(KATAKANA_CHARS, KANA_COMMON_CAHRS, withSpace ? SPACE_LIKE_CHARS : '');
    };

    VString.prototype.isOnlyAlphabet = function(withSpace) {
      return this.isOnly(ALPHA_CHARS, withSpace ? SPACE_LIKE_CHARS : '');
    };

    VString.prototype.isUnsignedInteger = function() {
      return this.isOnly(DIGIT_CHARS);
    };

    VString.prototype.isEMail = function() {
      var domain, escaped, isQuoted, local, mailMatch, patternBadChars, patternBadDot, patternEscapedBadChars, patternMail, patternQuoted, patternlocalNonQuoteds;
      if (this.getLength() > 256) {
        return false;
      }
      patternMail = /^([0-9a-z\.!\#$%&'*+\-\/=?^_`{|}~\(\)<>\[\]:;@,"\\\u0020]+)@((?:[0-9a-z][0-9a-z-]*\.)+[0-9a-z]{2,6}|\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])$/i;
      mailMatch = this.match(patternMail);
      if (!mailMatch) {
        return false;
      }
      local = mailMatch[1];
      domain = mailMatch[2];
      if (domain.length > 255) {
        return false;
      }
      if (local.length > 64) {
        return false;
      }
      patternQuoted = /^".+"$/g;
      isQuoted = patternQuoted.test(local);
      if (isQuoted) {
        local = local.replace(/^"|"$/g, '');
        patternEscapedBadChars = /\\"|\\\\/g;
        patternBadChars = /"|\\/;
        escaped = local.replace(patternEscapedBadChars, '');
        if (patternBadChars.test(escaped)) {
          return false;
        }
        return true;
      }
      patternBadDot = /^\.|\.{2,}|\.$/i;
      if (patternBadDot.test(local)) {
        return false;
      }
      patternlocalNonQuoteds = /^[0-9a-z\.!#$%&'*+\-\/=?^_`{|}~]+$/i;
      if (!patternlocalNonQuoteds.test(local)) {
        return false;
      }
      return true;
    };

    return VString;

  })(String);

  CustomRule = (function() {
    var _optimize, _optimizeValue, _optimizeValues, _toVString;

    CustomRule.prototype.isGroupRule = false;

    CustomRule.prototype._cast = null;

    CustomRule.prototype._valid = null;

    _toVString = function(values) {
      var key, value;
      if ($.isPlainObject(values)) {
        for (key in values) {
          value = values[key];
          values[key] = new VString(value);
        }
      } else {
        values = new VString(values);
      }
      return values;
    };

    _optimizeValue = function(value, ruleMaster) {
      if (/^:/.test(value)) {
        value = ruleMaster != null ? ruleMaster.getValue(value.replace(/^:/, '')) : void 0;
      }
      return value;
    };

    _optimizeValues = function(values, ruleMaster) {
      var res, value, _i, _len;
      res = [];
      for (_i = 0, _len = values.length; _i < _len; _i++) {
        value = values[_i];
        res.push(_optimizeValue(value, ruleMaster));
      }
      return res;
    };

    _optimize = function(value, ruleMaster) {
      var key, val;
      if ($.isPlainObject(value)) {
        for (key in value) {
          val = value[key];
          value[key] = _optimizeValues(val, ruleMaster);
        }
      } else {
        value = _optimizeValues(value, ruleMaster);
      }
      return value;
    };

    function CustomRule(options) {
      if ($.isPlainObject(options)) {
        this.isGroupRule = options.isGroupRule || false;
        this._cast = options.cast || null;
        this._valid = options.valid || null;
        if (!$.isFunction(this._valid)) {
          this.error();
        }
      } else {
        this.error();
      }
    }

    CustomRule.prototype.error = function() {
      throw new Error('Couldn\'t create instance of CustomRule because Invalid argument given.');
    };

    CustomRule.prototype.cast = function(element, values, args, ruleMaster) {
      if (args == null) {
        args = [];
      }
      values = _toVString(values);
      args = _optimize(args, ruleMaster);
      if ($.isFunction(this._cast)) {
        values = this._cast.apply(element, [values, args]);
      }
      return values;
    };

    CustomRule.prototype.valid = function(element, values, args, ruleMaster) {
      if (args == null) {
        args = [];
      }
      values = _toVString(values);
      args = _optimize(args, ruleMaster);
      return this._valid.apply(element, [values, args]);
    };

    return CustomRule;

  })();

  Validation = (function() {
    function Validation() {}

    Validation.customRules = {
      length: new CustomRule({
        cast: function(value) {
          return value.trim();
        },
        valid: function(value, length) {
          if (value.getLength() < length) {
            return '文字数が足りません';
          } else if (value.getLength() > length) {
            return '文字数がオーバーしています';
          }
        }
      }),
      hiragana: new CustomRule({
        cast: function(value) {
          return value.trim().toWide().toHiragana();
        },
        valid: function(value, args) {
          var withSpace;
          withSpace = args[0] === 'true';
          if (!value.isOnlyHiragana(withSpace)) {
            return '全角ひらがなで入力してください';
          }
        }
      }),
      katakana: new CustomRule({
        cast: function(value) {
          return value.trim().toWide().toKatakana();
        },
        valid: function(value, args) {
          var withSpace;
          withSpace = args[0] === 'true';
          if (!value.isOnlyKatakana(withSpace)) {
            return '全角カタカナで入力してください';
          }
        }
      }),
      alpha: new CustomRule({
        cast: function(value) {
          return value.trim().toNarrow();
        },
        valid: function(value) {
          if (!value.isOnlyAlphabet()) {
            return '半角アルファベットで入力してください';
          }
        }
      }),
      uint: new CustomRule({
        cast: function(value) {
          return value.trim().toNumber();
        },
        valid: function(value) {
          if (value.trim().toNumber() < 0) {
            return '0 以上を入力して下さい';
          }
          if (!value.isUnsignedInteger()) {
            return '半角数字を入力して下さい';
          }
        }
      }),
      char: new CustomRule({
        cast: function(value, query) {
          var hiragana, katakana;
          if (query == null) {
            query = [];
          }
          value = value.trim();
          query = query.join('');
          hiragana = /あ|かな?|ひらがな/.test(query);
          katakana = /ア|(?:カタ)?カナ?/.test(query);
          if (!(hiragana && katakana)) {
            if (hiragana) {
              value = value.toHiragana();
            }
            if (katakana) {
              value = value.toKatakana();
            }
          }
          if (/a|d|0|@|半角?(?:英|数|和|記)?/i.test(query)) {
            value = value.toNarrow();
          } else if (/ａ|Ａ|ｄ|Ｄ|０|＠|全角?/.test(query)) {
            value = value.toWide();
          }
          if (/ｱ|(?:ｶﾀ)?ｶﾅ?|半角?(?:カタ)?カナ?/.test(query)) {
            if (!hiragana) {
              value = value.toKatakana();
            }
            value = value.toNarrowJapnese();
          }
          return value;
        },
        valid: function(value, query) {
          var flag, out;
          if (query == null) {
            query = [];
          }
          query = query.join('');
          out = [];
          flag = 0;
          if (/半角?英数/.test(query)) {
            flag |= VString.ALPHANUMERIC;
            out.push('半角英数');
          } else {
            if (/a|半角?英字?/i.test(query)) {
              flag |= VString.ALPHABET;
              out.push('半角英字');
            }
            if (/d|0|半角?数字?/i.test(query)) {
              flag |= VString.DIGIT;
              out.push('半角数字');
            }
          }
          if (/全角?英数/.test(query)) {
            flag |= VString.FULLWIDTH_ALPHANUMERIC;
            out.push('全角英数');
          } else {
            if (/ａ|Ａ|全角?英字?/.test(query)) {
              flag |= VString.FULLWIDTH_ALPHABET;
              out.push('全角英字');
            }
            if (/ｄ|Ｄ|０|全角?数字?/.test(query)) {
              flag |= VString.FULLWIDTH_DIGIT;
              out.push('全角数字');
            }
          }
          if (/あ|かな?|ひらがな/.test(query)) {
            flag |= VString.HIRAGANA;
            out.push('全角ひらがな');
          }
          if (/ｱ|(?:ｶﾀ)?ｶﾅ?|半角?(?:カタ)?カナ?/.test(query)) {
            flag |= VString.NARROW_KATAKANA;
            out.push('半角カタカナ');
          } else if (/ア|(?:カタ)?カナ?/.test(query)) {
            flag |= VString.KATAKANA;
            out.push('全角カタカナ');
          }
          if (/＠|全角?(?:英字?)?(?:数字?)?和?記号?/.test(query)) {
            flag |= VString.FULLWIDTH_SIGN | VString.JAPANESE_SIGN;
            out.push('全角記号');
          } else {
            if (/@|半角?(?:英字?)?(?:数字?)?和?記号?/.test(query)) {
              flag |= VString.SIGN;
              out.push('半角記号');
            }
          }
          if (/j|和記号?/i.test(query)) {
            flag |= VString.JAPANESE_SIGN;
            out.push('和記号');
          }
          if (/-/.test(query)) {
            flag |= VString.HYPHEN;
          }
          if (!value.isOnly(flag)) {
            return "" + (out.join('/')) + "を入力してください";
          }
        }
      }),
      zenkaku: new CustomRule({
        cast: function(value) {
          return value.trim().toWide();
        },
        valid: function(value) {
          var v = value.toString();
          var ffgNoGoodCharacters = /[ -~｡-ﾟ0-9a-zA-Z㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡㍻〝〟№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼≒≡∫∮∑√⊥∠∟⊿∵∩∪犾猤猪獷玽珉珖珣珒琇珵琦琪琩琮瑢璉璟甁畯皂皜皞皛皦益睆劯砡硎硤硺礰礼神祥禔福禛竑竧靖竫箞精絈絜綷綠緖繒罇羡羽茁荢荿菇菶葈蒴蕓蕙蕫﨟薰蘒﨡蠇裵訒訷詹誧誾諟諸諶譓譿賰賴贒赶﨣軏﨤逸遧郞都鄕鄧釚釗釞釭釮釤釥鈆鈐鈊鈺鉀鈼鉎鉙鉑鈹鉧銧鉷鉸鋧鋗鋙鋐﨧鋕鋠鋓錥錡鋻﨨錞鋿錝錂鍰鍗鎤鏆鏞鏸鐱鑅鑈閒隆﨩隝隯霳霻靃靍靏靑靕顗顥飯飼餧館馞驎髙髜魵魲鮏鮱鮻鰀鵰鵫鶴鸙黑・ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ￢￤＇＂纊褜鍈銈蓜俉炻昱棈鋹曻彅丨仡仼伀伃伹佖侒侊侚侔俍偀倢俿倞偆偰偂傔僴僘兊兤冝冾凬刕劜劦勀勛匀匇匤卲厓厲叝﨎咜咊咩哿喆坙坥垬埈埇﨏塚增墲夋奓奛奝奣妤妺孖寀甯寘寬尞岦岺峵崧嵓﨑嵂嵭嶸嶹巐弡弴彧德忞恝悅悊惞惕愠惲愑愷愰憘戓抦揵摠撝擎敎昀昕昻昉昮昞昤晥晗晙晴晳暙暠暲暿曺朎朗杦枻桒柀栁桄棏﨓楨﨔榘槢樰橫橆橳橾櫢櫤毖氿汜沆汯泚洄涇浯涖涬淏淸淲淼渹湜渧渼溿澈澵濵瀅瀇瀨炅炫焏焄煜煆煇凞燁燾犱\'\)\;]/g;
          var match = v.match(ffgNoGoodCharacters);
          if (match) {
            return '「' + match.join(' ') + '」は入力できません';
          } else {
            return;
          }
        }
      }),
      hankaku: new CustomRule({
        cast: function(value) {
          return value.trim().toNarrow();
        },
        valid: function() {}
      }),
      notZero: new CustomRule({
        cast: function(value) {
          return value.trim().toNumber();
        },
        valid: function(value) {
          if (parseFloat(value) === 0) {
            return '0 は受け付けられません';
          }
        }
      }),
      range: new CustomRule({
        cast: function(value) {
          return value.trim().toNumber();
        },
        valid: function(value, options) {
          var max, min, step, unit;
          if (options == null) {
            options = [];
          }
          value = value.toNumber();
          min = options[0] || 0;
          max = options[1] || Infinity;
          step = options[2] || 1;
          unit = options[3] || '';
          if (!((min <= value && value <= max))) {
            if (max === Infinity) {
              return "" + min + unit + " 以上を入力してください";
            } else {
              return "" + min + unit + " から " + max + unit + " を入力してください";
            }
          }
          if (value % step) {
            return "" + step + unit + " 単位で入力してください";
          }
        }
      }),
      codeNum: new CustomRule({
        cast: function(value, args) {
          var digit, doesntCast, inAlpha, inHyphen;
          digit = parseInt(args[0], 10);
          inAlpha = args[1] === 'true' || args[1] === true || false;
          inHyphen = args[2] === 'true' || args[2] === true || false;
          doesntCast = args[3] === 'true' || args[3] === true || false;
          if (doesntCast) {
            return value;
          }
          return value.toCode(digit, inAlpha, inHyphen);
        },
        valid: function(value, args) {
          var digit, error, inAlpha, inHyphen, option;
          digit = parseInt(args[0], 10);
          inAlpha = args[1] === 'true' || args[1] === true || false;
          inHyphen = args[2] === 'true' || args[2] === true || false;
          option = DIGIT_CHARS;
          error = ['半角数字'];
          if (inAlpha) {
            option += ALPHA_CHARS;
            error = ['半角英数'];
          }
          if (inHyphen) {
            option += '-';
            error.push('ハイフン');
          }
          if (!value.isOnly(option)) {
            return "" + (error.join('/')) + "を入力してください";
          }
          if (!digit) {
            return;
          }
          if (value.getLength() < digit) {
            return '桁数が足りません';
          } else if (value.getLength() > digit) {
            return '桁数がオーバーしています';
          }
        }
      }),
      tel: new CustomRule({
        isGroupRule: true,
        cast: function(values) {
          var key, value;
          for (key in values) {
            value = values[key];
            values[key] = value.toNarrow();
            values[key] = value.toCode();
          }
          return values;
        },
        valid: function(values) {
          var key, res, value, _ref;
          res = '';
          for (key in values) {
            value = values[key];
            if (!value.isUnsignedInteger()) {
              return '半角数字を入力して下さい';
            }
            res += value;
          }
          if (!((10 <= (_ref = res.length) && _ref <= 11))) {
            return '電話番号は10か11桁になります';
          }
        }
      }),
      mail: new CustomRule({
        isGroupRule: true,
        cast: function(value) {
          if ($.isPlainObject(value)) {
            value.local = value.local.trim().toNarrow();
            value.domain = value.domain.trim().toNarrow();
            return value;
          } else {
            return value.trim();
          }
        },
        valid: function(value) {
          if ($.isPlainObject(value)) {
            value = value.local.clone().concat('@', value.domain);
          } else {

          }
          if (!value.isEMail()) {
            return 'メールアドレスの形式が間違っています';
          }
        }
      }),
      date: new CustomRule({
        isGroupRule: true,
        valid: function(values, options) {
          var $age, $elapsedMonth, $elapsedYear, $form, age, ageLimits, ageLimitsUp, data, date, elapsedMonth, elapsedYear, fullYear, gengo, isAgeCheck, month, rangeError, thedate, today, year, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
          $form = $(this.year).parents('form');
          if ((values.gengo && values.gengo.empty()) || (values.year && values.year.empty()) || (values.month && values.month.empty()) || (values.date && values.date.empty())) {
            return '必須項目です';
          }
          gengo = (_ref = values.gengo) != null ? _ref.toString() : void 0;
          year = (_ref1 = values.year) != null ? _ref1.toNumber() : void 0;
          month = (_ref2 = values.month) != null ? _ref2.toNumber() : void 0;
          date = (_ref3 = values.date) != null ? _ref3.toNumber() : void 0;
          ageLimits = ((_ref4 = options.age) != null ? _ref4[0] : void 0) || ((_ref5 = options.year) != null ? _ref5[0] : void 0) || Infinity;
          ageLimitsUp = ((_ref6 = options.age) != null ? _ref6[1] : void 0) || ((_ref7 = options.year) != null ? _ref7[1] : void 0) || -Infinity;
          isAgeCheck = isFinite(ageLimits) || isFinite(ageLimitsUp);
          $age = $(this.age);
          $elapsedYear = $(this.elapsedYear);
          $elapsedMonth = $(this.elapsedMonth);
          if (gengo) {
            if (isNaN(month)) {
              if (rangeError = checkGengo(gengo, year)) {
                if (rangeError.end != null) {
                  return "" + gengo + " は " + rangeError.end.year + " 年までです";
                }
              }
              month = 1;
            } else if (isNaN(date)) {
              if (rangeError = checkGengo(gengo, year, month)) {
                if (rangeError.end != null) {
                  return "" + gengo + " は " + rangeError.end.year + " 年 " + rangeError.end.month + " 月までです";
                } else if (rangeError.start != null) {
                  return "" + gengo + " は " + rangeError.start.month + " 月からです";
                }
              }
              date = 1;
            } else {
              if (rangeError = checkGengo(gengo, year, month, date)) {
                if (rangeError.end != null) {
                  return "" + gengo + " は " + rangeError.end.year + " 年 " + rangeError.end.month + " 月 " + rangeError.end.date + " 日までです";
                } else if (rangeError.start != null) {
                  return "" + gengo + " は " + rangeError.start.month + " 月 " + rangeError.start.date + " 日からです";
                }
              }
            }
            fullYear = w2s(year, gengo);
          } else {
            fullYear = year;
            if (isNaN(month)) {
              month = 1;
            }
            if (isNaN(date)) {
              date = 1;
            }
          }
          thedate = new Date(fullYear, month - 1, date, 0, 0, 0, 0);
          if (!((1 <= month && month <= 12))) {
            return "" + month + " 月はありません";
          }
          if (date !== thedate.getDate()) {
            return "" + year + " 年 " + month + " 月に " + date + " 日はありません";
          }
          today = new Date();
          today.setHours(0);
          today.setMinutes(0);
          today.setSeconds(0);
          today.setMilliseconds(0);
          age = today.getFullYear() - thedate.getFullYear();
          if (today.getMonth() <= thedate.getMonth() && today.getDate() < thedate.getDate()) {
            age -= 1;
          }
          elapsedYear = age;
          elapsedMonth = today.getMonth() - thedate.getMonth();
          if (today.getDate() < thedate.getDate()) {
            elapsedMonth -= 1;
          }
          if (elapsedMonth < 0) {
            elapsedMonth = 12 + elapsedMonth;
            age = elapsedYear -= 1;
          }
          data = {
            gengo: gengo,
            year: fullYear,
            month: month,
            date: date,
            age: age,
            thedate: thedate,
            today: today,
            elapsedYear: elapsedYear,
            elapsedMonth: elapsedMonth
          };
          $form.trigger('validation.date', data);
          if (isAgeCheck) {
            $age.val(age);
            if (age < ageLimits && ageLimitsUp < age) {
              $age.val('');
              return "" + ageLimits + " 歳以上 " + ageLimitsUp + " 歳以下 の方しかお申込みできません";
            } else if (age < ageLimits) {
              $age.val('');
              return "" + ageLimits + " 歳以上の方しかお申込みできません";
            } else if (ageLimitsUp < age) {
              $age.val('');
              return "" + ageLimitsUp + " 歳以下 の方しかお申込みできません";
            }
          }
          if (age < 0) {
            $age.val('');
            return "未来の日付です";
          }
          $elapsedYear.val(elapsedYear);
          $elapsedMonth.val(elapsedMonth);
        }
      })
    };

    return Validation;

  })();

  RuleMaster = (function() {
    RuleMaster.prototype.form = null;

    RuleMaster.prototype.debug = false;

    RuleMaster.prototype.rules = null;

    RuleMaster.prototype.onShowMessage = null;

    RuleMaster.prototype.onValidateEnd = null;

    function RuleMaster($form, rules, onShowMessage, onValidateEnd) {
      var $elem, elem, groupMatch, groupName, groups, rule, ruleName, type;
      groups = {};
      this.rules = {};
      for (ruleName in rules) {
        rule = rules[ruleName];
        $elem = $("[name='" + ruleName + "']");
        if (!$elem.length) {
          continue;
        }
        elem = $elem[0];
        type = elem.type;
        switch (type.toLowerCase()) {
          case 'submit':
          case 'button':
          case 'image':
            continue;
        }
        groupMatch = rule.match(/group:([^\s]+)(?:\s+|$)/i);
        if (groupMatch) {
          groupName = groupMatch[1];
          if (groups[groupName] == null) {
            groups[groupName] = [];
          }
          groups[groupName].push(new Rule(ruleName, rule, $elem, this, groupName));
        } else {
          this.rules[ruleName] = new Rule(ruleName, rule, $elem, this);
        }
      }
      for (groupName in groups) {
        rules = groups[groupName];
        this.rules[groupName] = new RuleGroup(groupName, rules, this);
      }
      this.form = $form[0];
      this.onShowMessage = onShowMessage;
      this.onValidateEnd = onValidateEnd;
    }

    RuleMaster.prototype.getRule = function(name) {
      var cRule, rule, ruleName, _ref;
      _ref = this.rules;
      for (ruleName in _ref) {
        rule = _ref[ruleName];
        if (rule instanceof Rule) {
          if (name === ruleName) {
            return rule;
          }
        }
        if (rule instanceof RuleGroup) {
          cRule = rule.getRule(name);
          if (cRule) {
            return cRule;
          }
        }
      }
      return null;
    };

    RuleMaster.prototype.getValue = function(name, typeofVString) {
      var res, rule;
      rule = this.getRule(name);
      if (rule) {
        res = rule.getValue();
        if (typeofVString) {
          res = new VString(res);
        }
      }
      return res;
    };

    RuleMaster.prototype.validate = function() {
      var error, message, messages, messagesArray, rule, ruleName, _ref;
      error = false;
      messages = {};
      messagesArray = [];
      _ref = this.rules;
      for (ruleName in _ref) {
        rule = _ref[ruleName];
        message = rule.validate();
        if (this.debug) {
          log(ruleName, "(" + (rule.putValue()) + ")=>(" + (rule.putCastedValue()) + ")", message);
        }
        messages[ruleName] = message;
        messagesArray.push(message);
        if (message) {
          error = true;
        }
      }
      this.onValidateEnd.call(this.form, !error, messages, messagesArray);
      return !error;
    };

    return RuleMaster;

  })();

  RuleGroup = (function() {
    RuleGroup.prototype.name = '';

    RuleGroup.prototype.length = 0;

    RuleGroup.prototype.$elem = null;

    RuleGroup.prototype.groupRules = null;

    RuleGroup.prototype.requireRule = null;

    RuleGroup.prototype.master = null;

    RuleGroup.prototype.values = null;

    RuleGroup.prototype.castedValues = null;

    function RuleGroup(groupName, rules, master) {
      var i, inName, inRule, isGroupRule, label, name, rule, _i, _j, _len, _len1, _ref;
      this.name = groupName;
      this.$elem = $();
      this.groupRules = {};
      this.values = {};
      this.castedValues = {};
      this.master = master;
      for (i = _i = 0, _len = rules.length; _i < _len; i = ++_i) {
        rule = rules[i];
        name = rule.name;
        this.$elem = $.merge(this.$elem, rule.$elem);
        _ref = rule.rules;
        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
          inRule = _ref[_j];
          inName = inRule.name;
          isGroupRule = inRule.method.isGroupRule;
          if (isGroupRule) {
            if (this.groupRules[inName] == null) {
              this.groupRules[inName] = {};
            }
            label = rule.groupLabel = inRule.label || name;
            this.groupRules[inName][label] = inRule.params;
          }
        }
        if (!this.requireRule) {
          if (rule.groupRequireRule) {
            this.requireRule = rule.groupRequireRule;
          }
        }
        this[i] = rule;
      }
      this.length = i;
    }

    RuleGroup.prototype.getRule = function(name) {
      var rule, _i, _len;
      for (_i = 0, _len = this.length; _i < _len; _i++) {
        rule = this[_i];
        if (name === rule.name) {
          return rule;
        }
      }
      return null;
    };

    RuleGroup.prototype.each = function(callback) {
      var i, rule;
      for (i in this) {
        rule = this[i];
        if (isFinite(i)) {
          callback.call(rule, parseInt(i, 10));
        }
      }
    };

    RuleGroup.prototype.empty = function() {
      var res;
      res = true;
      this.each(function() {
        if (!this.empty()) {
          return res = false;
        }
      });
      return res;
    };

    RuleGroup.prototype.getValues = function() {
      var res;
      res = {};
      this.each(function() {
        if (this.groupLabel) {
          res[this.groupLabel] = this.getValue();
        } else {
          res[this.name] = this.getValue();
        }
      });
      return res;
    };

    RuleGroup.prototype.getElements = function() {
      var res;
      res = {};
      this.each(function() {
        if (this.groupLabel) {
          res[this.groupLabel] = this.$elem[0];
        } else {
          res[this.name] = this.$elem[0];
        }
      });
      return res;
    };

    RuleGroup.prototype.putValue = function() {
      var n, res, value, _ref;
      res = [];
      _ref = this.values;
      for (n in _ref) {
        value = _ref[n];
        res.push(value);
      }
      return res.join(',');
    };

    RuleGroup.prototype.putCastedValue = function() {
      var n, res, value, _ref;
      res = [];
      _ref = this.castedValues;
      for (n in _ref) {
        value = _ref[n];
        res.push(value);
      }
      return res.join(',');
    };

    RuleGroup.prototype.check = function() {
      var checkValues, customRule, elem, elems, errorMessage, groupRule, groupRuleName, groupRuleValue, key, name, opt, toGroupCheck, value, _ref, _ref1;
      name = this.name;
      toGroupCheck = false;
      errorMessage = '';
      elems = this.getElements();
      this.values = this.getValues();
      if (this.requireRule != null) {
        customRule = Validation.customRules[this.requireRule.name];
        this.castedValues = customRule.cast(elems, this.values, this.requireRule.params, this.master);
        errorMessage = customRule.valid(elems, this.castedValues, this.requireRule.params, this.master);
        if (errorMessage) {
          // 追記
          _ref1 = this.castedValues;
          for (name in _ref1) {
            if (!__hasProp.call(_ref1, name)) continue;
            value = _ref1[name];
            elem = elems[name];
            if (!/select|checkbox|radio/i.test(elem.type)) {
              elem.value = value.toString();
            }
          }
          // 追記ここまで
          return errorMessage;
        }
        this.require = false;
      }
      this.each(function() {
        if (!toGroupCheck) {
          if (this.require) {
            toGroupCheck = true;
            return;
          }
          if (!this.empty()) {
            toGroupCheck = true;
          }
        }
      });
      opt = {
        isCasted: false
      };
      if (toGroupCheck) {
        _ref = this.groupRules;
        for (groupRuleName in _ref) {
          groupRule = _ref[groupRuleName];
          checkValues = {};
          for (key in groupRule) {
            groupRuleValue = groupRule[key];
            checkValues[key] = this.values[key];
          }
          customRule = Validation.customRules[groupRuleName];
          this.castedValues = customRule.cast(elems, checkValues, groupRule, this.master);
          errorMessage = customRule.valid(elems, this.castedValues, groupRule, this.master);
          if (errorMessage) {
            return errorMessage;
          }
        }
        if (!errorMessage) {
          this.each(function() {
            if (!errorMessage) {
              return errorMessage = this.check(opt);
            }
          });
        }
      }
      if (!opt.isCasted) {
        _ref1 = this.castedValues;
        for (name in _ref1) {
          if (!__hasProp.call(_ref1, name)) continue;
          value = _ref1[name];
          elem = elems[name];
          if (!/select|checkbox|radio/i.test(elem.type)) {
            elem.value = value.toString();
          }
        }
      }
      return errorMessage;
    };

    RuleGroup.prototype.validate = function() {
      var errorMessage;
      errorMessage = this.check();
      return this[0].message(!errorMessage, errorMessage);
    };

    return RuleGroup;

  })();

  Rule = (function() {
    Rule.prototype.master = null;

    Rule.prototype.name = '';

    Rule.prototype.groupName = null;

    Rule.prototype.groupLabel = '';

    Rule.prototype.ruleQuery = '';

    Rule.prototype.type = null;

    Rule.prototype.$elem = null;

    Rule.prototype.require = false;

    Rule.prototype.requireRule = null;

    Rule.prototype.groupRequireRule = null;

    Rule.prototype.callback = [];

    Rule.prototype.rules = [];

    Rule.prototype.ignore = [];

    Rule.prototype.value = '';

    Rule.prototype.castedValue = '';

    function Rule(ruleName, rule, $elem, master, groupName) {
      var callback, groupRequireRule, ignore, key, label, method, require, requireRule, rules, rulesQuery, rulesQuerySplit, valueStrings, values, _i, _len, _ref, _ref1;
      rulesQuerySplit = rule.split(/\s+/);
      rules = [];
      require = false;
      ignore = [];
      callback = [];
      for (_i = 0, _len = rulesQuerySplit.length; _i < _len; _i++) {
        rulesQuery = rulesQuerySplit[_i];
        if (!rulesQuery) {
          continue;
        }
        key = rulesQuery.match(/^[^:\(\)@,]+/)[0];
        label = (_ref = rulesQuery.match(/^[^:\(\)@,]+:([^:\(\)@,]+)/)) != null ? _ref[1] : void 0;
        valueStrings = (_ref1 = rulesQuery.match(/^[^\(\)@,]+\(([^\(\)]+)\)/)) != null ? _ref1[1] : void 0;
        values = (valueStrings != null ? valueStrings.split(',') : void 0) || [];
        switch (key.toLowerCase()) {
          case 'require':
            if (label) {
              if (Validation.customRules[label] != null) {
                if (groupName) {
                  groupRequireRule = {
                    name: label,
                    params: values
                  };
                } else {
                  requireRule = {
                    name: label,
                    params: values
                  };
                }
              } else {
                warn("CustomRule(RequireGroupRule) " + label + " is not defined.");
              }
            } else {
              require = true;
            }
            break;
          case 'ignore':
            ignore = values;
            break;
          case 'call':
            callback.push(label);
            break;
          case 'group':
            break;
          default:
            method = Validation.customRules[key];
            if (method != null) {
              rules.push({
                name: key,
                label: label,
                params: values,
                method: method,
                toString: function() {
                  return "Rule::" + this.name + "(" + (this.params.join(',')) + ")";
                }
              });
            } else {
              warn("CustomRule " + key + " is not defined.");
            }
        }
      }
      this.master = master;
      this.name = ruleName;
      this.ruleQuery = rule;
      this.type = $elem[0].type;
      this.$elem = $elem;
      this.require = require;
      this.requireRule = requireRule;
      this.rules = rules;
      this.ignore = ignore;
      this.groupName = groupName || null;
      this.groupRequireRule = groupRequireRule || null;
      this.callback = callback;
    }

    Rule.prototype.getValue = function() {
      var ignore, value, _i, _len, _ref;
      value = this.$elem.val();
      switch (this.type) {
        case 'select-one':
          _ref = this.ignore;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            ignore = _ref[_i];
            if (value === ignore) {
              return null;
            }
          }
          return value;
        case 'checkbox':
        case 'radio':
          return this.$elem.filter(':checked').val() || null;
        default:
          return value;
      }
    };

    Rule.prototype.putValue = function() {
      return String(this.value);
    };

    Rule.prototype.putCastedValue = function() {
      return String(this.castedValue);
    };

    Rule.prototype.empty = function() {
      var value;
      value = this.getValue();
      return !value;
    };

    Rule.prototype.message = function(passed, message) {
      this.master.onShowMessage.call(this.$elem[0], passed, message);
      return message;
    };

    Rule.prototype.check = function(opt) {
      var elem, errorMessage, method, rule, _i, _len, _ref;
      this.value = this.getValue();
      this.castedValue = this.value;
      elem = this.$elem[0];
      if (this.requireRule != null) {
        method = Validation.customRules[this.requireRule.name];
        this.castedValue = method.cast(elem, this.castedValue, this.requireRule.params, this.master);
        errorMessage = method.valid(elem, this.castedValue, this.requireRule.params, this.master);
        if (errorMessage) {
          return errorMessage;
        }
        this.require = false;
      }
      if (this.require) {
        if (this.empty()) {
          return '必須項目です';
        }
      } else {
        if (this.empty()) {
          return '';
        }
      }
      _ref = this.rules;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rule = _ref[_i];
        method = Validation.customRules[rule.name];
        if (method) {
          if (method.isGroupRule && this.groupName) {
            continue;
          }
          this.castedValue = method.cast(elem, this.castedValue, rule.params, this.master);
          errorMessage = method.valid(elem, this.castedValue, rule.params, this.master);
          if (errorMessage) {
            return errorMessage;
          }
        }
      }
      if (!/select|checkbox|radio/i.test(this.type)) {
        this.$elem.val(this.castedValue.toString());
        opt.isCasted = true;
      }
      return '';
    };

    Rule.prototype.validate = function(isGroupCheck) {
      var callback, errorMessage, _i, _len, _ref, _ref1;
      if (isGroupCheck && this.groupName) {
        return this.master.rules[this.groupName].validate();
      }
      errorMessage = this.check({});
      _ref = this.callback;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        callback = _ref[_i];
        if ((_ref1 = this.master.rules[callback]) != null) {
          _ref1.validate();
        }
      }
      return this.message(!errorMessage, errorMessage);
    };

    return Rule;

  })();

  $.fn.validation = function(rulesOrMethod, customRules, options) {
    var $elem, customRuleName, customRuleOption, elem, methodName, rules;
    $elem = this.eq(0);
    elem = $elem[0];
    if (!elem) {
      return this;
    }
    if (elem.nodeName.toLowerCase() !== 'form') {
      return this;
    }
    options = $.extend({
      when: Validation.when || 'each',
      onShowMessage: Validation.showMessage,
      onValidateEnd: Validation.validateEnd
    }, options);
    rules = $elem.data('validation');
    if (rules) {
      methodName = String(rulesOrMethod).toLowerCase();
      switch (methodName) {
        case 'validate':
          rules.validate();
          break;
        case 'getrules':
          return rules;
      }
    } else {
      if ($.isPlainObject(customRules)) {
        for (customRuleName in customRules) {
          customRuleOption = customRules[customRuleName];
          if (Validation.customRules[customRuleName]) {
            if (customRuleOption.valid) {
              Validation.customRules[customRuleName]._valid = customRuleOption.valid;
            }
            if (customRuleOption.cast) {
              Validation.customRules[customRuleName]._cast = customRuleOption.cast;
            }
          } else {
            Validation.customRules[customRuleName] = new CustomRule(customRuleOption);
          }
        }
      }
      rules = new RuleMaster(this, rulesOrMethod, options.onShowMessage, options.onValidateEnd);
      rules.debug = DEBUG_MODE;
      $elem.data('validation', rules);
      $elem.submit(function(e, data) {
        if (data != null ? data.noValidate : void 0) {
          return true;
        }
        return rules.validate();
      });
      if (options.when.toString().toLowerCase() === 'each') {
        $elem.on('blur change', 'input, select, textarea', function(e, params) {
          var $this, name, rule, type;
          if ((params != null) && params.fromTrigger) {
            return true;
          }
          $this = $(this);
          name = this.name;
          type = this.type;
          switch (type.toLowerCase()) {
            case 'hidden':
            case 'submit':
            case 'button':
            case 'image':
              break;
            default:
              rule = rules.getRule(name);
              rule.validate(true);
          }
          return true;
        });
      }
      if (DEBUG_MODE) {
        log(rules);
      }
    }
    return this;
  };

  Validation.showMessage = function(passed, message) {
    var $ng, $ok, $td, $this, $tr;
    $this = $(this);
    $tr = $this.parents('tr');
    $td = $tr.find('td.check');
    $ok = $td.find('.ok');
    $ng = $td.find('.form_ng');
    if (passed) {
      $tr.removeClass('error');
      $ok.show();
      $ng.hide();
    } else {
      $tr.addClass('error');
      $ok.hide();
      $ng.show().text(message);
    }
    return passed;
  };

  Validation.validateEnd = function(passed, messages, messagesArray) {
    var top;
    if (!passed) {
      top = $(this).find('.error').eq(0).offset().top;
      return $('html,body').animate({
        scrollTop: top
      }, 600);
    }
  };

  if (typeof console !== 'undefined' && typeof console.log === 'object') {
    (function() {
      var bind, method, methods, slice, _i, _len;
      slice = Array.prototype.slice;
      bind = Function.prototype.bind || function(context) {
        var args, self;
        args = slice.call(arguments, 1);
        self = this;
        return function() {
          return self.apply(context, args.concat(slice.call(arguments)));
        };
      };
      methods = ['log', 'info', 'warn', 'error', 'assert', 'dir', 'clear', 'profile', 'profileEnd'];
      for (_i = 0, _len = methods.length; _i < _len; _i++) {
        method = methods[_i];
        console[method] = bind.call(Function.prototype.call, console[method], console);
      }
    })();
  }

  log = function() {
    var _ref;
    if (typeof console !== "undefined" && console !== null) {
      if ((_ref = console.log) != null) {
        _ref.apply(console, [log.i++].concat($.makeArray(arguments)));
      }
    }
    return arguments;
  };

  log.i = 0;

  warn = function() {
    var _ref;
    if (typeof console !== "undefined" && console !== null) {
      if ((_ref = console.warn) != null) {
        _ref.apply(console, arguments);
      }
    }
    return arguments;
  };

  Validation.String = VString;

  $.Validation = Validation;

  return;

}).call(this);
