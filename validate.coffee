do (w = @, $ = @jQuery) ->
	'use strict'

	DEBUG_MODE = on

	# 定数
	SIGN_CHARS = '\\u0020-\\u002F\\u003A-\\u0041\\u005B-\\u0061\\u007B-\\u007E' # [ !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]
	DIGIT_CAHRS = '0-9'
	ALPHA_CHARS = 'A-Za-z'
	ALPHANUMERIC_CHARS_WITH_SIGN = '\\u0020-\\u007E' # [ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]
	FULLWIDTH_SING_CHARS = '\\uFF01-\\uFF0F\\uFF1A-\\uFF20\\uFF3B-\\uFF40\\uFF5B-\\uFF5E' # [！＂＃＄％＆＇（）＊＋，－．／：；＜＝＞？＠［＼］＾＿｀｛｜｝～]
	FULLWIDTH_DIGIT_CHARS = '\\uFF10-\\uFF19' # [０１２３４５６７８９]
	FULLWIDTH_ALPHA_CHARS = '\\uFF21-\\uFF3A\\uFF41-\\uFF5A' # [ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ]
	FULLWIDTH_ALPHANUMERIC_CHARS_WITH_SIGN = '\\uFF01-\\uFF5F' # [！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［＼］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～]
	HIRAGANA_CHARS = '\\u3041-\\u3096\\u309D-\\u309F' # [ぁ-ゖゝ-ゟ]
	KATAKANA_CHARS = '\\u30A1-\\u30FA\\u30FD\\u30FF' # [ァ-ヺヽ-ヿ]
	KANA_COMMON_CAHRS = '\u3099-\u309C\u30FC' # [゛゜(結合文字含む)ー]
	JAPANESE_SIGN_CHARS = '\u3000-\u3036\u30FB\\uFF5E' # [　、。〃〄々〆〇〈〉《》「」『』【】〒〓〔〕〖〗〘〙〚〛〜〝〞〟〠〡〢〣〤〥〦〧〨〩〪〭〮〯〫〬〰〱〲〳〴〵〶・～] ※ 波ダッシュ・全角チルダ問題があるため 全角チルダを含めることとする (http://ja.wikipedia.org/wiki/Unicode#.E6.B3.A2.E3.83.80.E3.83.83.E3.82.B7.E3.83.A5.E3.83.BB.E5.85.A8.E8.A7.92.E3.83.81.E3.83.AB.E3.83.80.E5.95.8F.E9.A1.8C)
	NARROW_KATAKANA_CHARS = '\\uFF66-\\uFF9F' # [ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ]
	NARROW_JAPANESE_SIGN_CHARS = '\\uFF61-\\uFF65' # [｡｢｣､･]
	SPACE_LIKE_CHARS = '\\s\\n\\t\\u0009\\u0020\\u00A0\\u2002-\\u200B\\u3000\\uFEFF'

	# 和暦を西暦
	w2s = (year, gengo) ->
		gengos =
			'明治': 1868
			'大正': 1912
			'昭和': 1926
			'平成': 1989
		gengos[gengo] + year - 1
	checkGengo = (gengo, year, month, date) ->
		# 戻り値はハッシュ
		# 明治: 9月8日 - 45年7月29日
		# 大正: 7月30日 - 15年12月24日
		# 昭和: 12月25日 - 64年1月7日
		# 平成: 1月8日 -
		gengos =
			'明治': [
				9 # 月
				8 # 日から
				45 # 年
				7 # 月
				29 # 日まで
			]
			'大正': [
				7 # 月
				30 # 日から
				15 # 年
				12 # 月
				24 # 日まで
			]
			'昭和': [
				12 # 月
				25 # 日から
				64 # 年
				1 # 月
				7 # 日まで
			]
			'平成': [
				1 # 月
				8 # 日から
				Infinity # 年
				Infinity # 月
				Infinity # 日まで
			]
		start =
			month: gengos[gengo][0]
			date: gengos[gengo][1]
		end =
			year: gengos[gengo][2]
			month: gengos[gengo][3]
			date: gengos[gengo][4]
		# 年だけチェック
		if isNaN month
			if end.year < year
				return end: end
		# 年と月でのチェック
		else if isNaN date
			if end.year < year or (end.year is year and end.month < month)
				return end: end
			else if 1 is year and start.month > month
				return start: start
		# 年・月・日でのチェック
		else
			if end.year < year or (end.year is year and end.month < month) or (end.year is year and end.month is month and end.date < date)
				return end: end
			else if (1 is year and start.month > month) or (1 is year and start.month is month and start.date > date)
				return start: start
		return null

	# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- # Class #
	class VString extends String
		# ----- 使用上の注意 ----- #
		# 1. lengthプロパティの性質だけは継承できない。
		# 2. replaceメソッドを拡張
		# ----- ----- ----- ----- ----- # Private Method
		_rIncluded = (chars) ->
			new RegExp "[#{chars.join('')}]", 'g'
		# ----- ----- ----- ----- ----- # Class Member
		@SIGN: 1 << 1 # 半角記号
		@DIGIT: 1 << 2 # 半角数字
		@ALPHABET: 1 << 3 # 半角英字
		@HIRAGANA: 1 << 4 # ひらがな
		@KATAKANA: 1 << 5 # カタカナ
		@FULLWIDTH_SIGN: 1 << 6 # 全角記号
		@FULLWIDTH_DIGIT: 1 << 7 # 全角数字
		@FULLWIDTH_ALPHABET: 1 << 8 # 全角英字
		@JAPANESE_SIGN: 1 << 9 # 全角和記号
		@NARROW_KATAKANA: 1 << 10 # 半角カタカナ
		@NARROW_JAPANESE_SIGN: 1 << 11 # 半角和記号
		@ALPHANUMERIC: @DIGIT | @ALPHABET # 半角英数字
		@FULLWIDTH_ALPHANUMERIC: @FULLWIDTH_DIGIT | @FULLWIDTH_ALPHABET # 全角英字
		@KANA: @HIRAGANA | @KATAKANA # ひらがな + カタカナ
		@KANA_WITH_SIGN: @KANA | @JAPANESE_SIGN # ひらがな + カタカナ + 和記号
		@NARROW_JAPANESE: @NARROW_KATAKANA | @NARROW_JAPANESE_SIGN # 半角カナ
		@ANK: @ALPHANUMERIC | @NARROW_JAPANESE # ANK(半角英数カナ)
		# ----- ----- ----- ----- ----- # Instance Member
		_: ''
		# ----- ----- ----- ----- ----- # Instance Method
		constructor: (str = '') ->
			@_ = str + ''
		# Override
		toString: ->
			@_
		# Override
		valueOf: ->
			@toString()
		# Override
		concat: (strs...) ->
			@string super strs.join ''
		# Override
		replace: (pattern, replacement) ->
			res = @clone()
			if $.isPlainObject pattern
				for char, newChar of pattern
					res = res.replace new RegExp(char, 'g'), newChar
			else
				res = new @constructor super pattern, replacement
			@string res
			res
		# Override
		slice: (from, to) ->
			@string super from, to
		# Override
		substr: (from, length) ->
			@string super form, length
		# Override
		substring: (from, to) ->
			@string super from, to
		# Override
		toLowerCase: ->
			@string super()
		# Override
		toUpperCase: ->
			@string super()
		# Override?
		trim: ->
			@remove new RegExp "^[#{SPACE_LIKE_CHARS}]+|[#{SPACE_LIKE_CHARS}]+$", 'g'
		# セッターメソッド
		string: (str = '') ->
			new @constructor @_ = str + ''
		# 文字列長
		getLength: ->
			@_.length
		empty: ->
			!@_
		# クローンを返す
		clone: ->
			new @constructor @_
		# マッチした文字列を削除
		remove: (pattern) ->
			@replace pattern, ''
		# マッチしたかどうか論理値で返す
		test: (pattern) ->
			unless pattern instanceof RegExp
				pattern = new RegExp pattern
			pattern.test @
		# 手前に挿入
		add: (str = '') ->
			@string str + @_
		# 文字列が同じかどうか
		is: (str) ->
			@_ is String str
		# 一文字ずつコールバックによって置換
		replaceEach: (callback) ->
			unless $.isFunction callback
				return @
			_this = @
			@replace /./g, (str) ->
				res = callback.call _this, str
				String if res? then res else matches[0]
		# 置き換える
		change: (replacement) ->
			res = if $.isFunction replacement then replacement @ else replacement
			@string res
		# 指定されたキャラクターだけで校正されているかどうか論理値で返す
		# isOnly(chars[, chars...[, withSpace]])
		# isOnly(charsFlag[, withSpace])
		isOnly: (chars...) ->
			flag = chars[0]
			withSpace = chars[chars.length - 1]
			if flag - 0 is flag # typeof Number
				chars = []
				if (flag & VString.SIGN) isnt 0
					chars.push SIGN_CHARS
				if (flag & VString.DIGIT) isnt 0
					chars.push DIGIT_CAHRS
				if (flag & VString.ALPHABET) isnt 0
					chars.push ALPHA_CHARS
				if (flag & VString.HIRAGANA) isnt 0
					chars.push HIRAGANA_CHARS + KANA_COMMON_CAHRS
				if (flag & VString.KATAKANA) isnt 0
					chars.push KATAKANA_CHARS + KANA_COMMON_CAHRS
				if (flag & VString.FULLWIDTH_SIGN) isnt 0
					chars.push FULLWIDTH_SING_CHARS
				if (flag & VString.FULLWIDTH_DIGIT) isnt 0
					chars.push FULLWIDTH_DIGIT_CHARS
				if (flag & VString.FULLWIDTH_ALPHABET) isnt 0
					chars.push FULLWIDTH_ALPHA_CHARS
				if (flag & VString.JAPANESE_SIGN) isnt 0
					chars.push JAPANESE_SIGN_CHARS
				if (flag & VString.NARROW_KATAKANA) isnt 0
					chars.push NARROW_KATAKANA_CHARS
				if (flag & VString.NARROW_JAPANESE_SIGN) isnt 0
					chars.push NARROW_JAPANESE_SIGN_CHARS
				# log flag, chars
			if withSpace is !!withSpace # typeof Boolean
				chars.push SPACE_LIKE_CHARS
			rChars = new RegExp("^[#{chars.join('')}]+$", 'g')
			# log rChars.source
			rChars.test @
		# 指定した数値分のコード番号をずらす
		# n は数値 もしくは キャラクターをキー、ずらす数値を値としたハッシュ
		shift: (n) ->
			res = @clone()
			if isFinite n
				res = res.replaceEach (char) ->
					String.fromCharCode char.charCodeAt(0) + parseInt n, 10
			else if $.isPlainObject n
				for chars, shift of n
					res = res.replace _rIncluded([chars]), (char) ->
						String.fromCharCode char.charCodeAt(0) + parseInt shift, 10
			else
				throw new Error 'Invalid arguments'
			@string res
			res
		# 濁点・半濁点を結合文字に変換
		combinate: ->
			@replace
				'\u309B': '\u3099' # 濁点
				'\u309C': '\u309A' # 半濁点
		# カタカナからひらがなへ
		toHiragana: (combinate = false) ->
			hash = {}
			hash[KATAKANA_CHARS] = -96
			res = @
				.toWideKatakana()
				.replace
					'ヷ': 'わ゛'
					'ヸ': 'ゐ゛'
					'ヹ': 'ゑ゛'
					'ヺ': 'を゛'
				.shift hash
			if combinate then res.combinate() else res
		# ひらがなからカタカナへ
		toKatakana: ->
			hash = {}
			hash[HIRAGANA_CHARS] = +96
			@
				.toWideKatakana()
				.replace(/\u308F(?:\u309B|\u3099|\uFF9E)/g, '\u30F7') # わ゛=> ヷ
				.replace(/\u3090(?:\u309B|\u3099|\uFF9E)/g, '\u30F8') # ゐ゛=> ヸ
				.replace(/\u3091(?:\u309B|\u3099|\uFF9E)/g, '\u30F9') # ゑ゛=> ヹ
				.replace(/\u3092(?:\u309B|\u3099|\uFF9E)/g, '\u30FA') # を゛=> ヺ
				.shift hash
		# 半角カタカナへ
		toNarrowKatakana: ->
			@
				.replace(/\u309B|\u3099/g, '\uFF9E') # 濁点
				.replace(/\u309C|\u309A/g, '\uFF9F') # 半濁点
				.replace
					'ァ': 'ｧ', 'ィ': 'ｨ', 'ゥ': 'ｩ', 'ェ': 'ｪ', 'ォ': 'ｫ', 'ャ': 'ｬ'
					'ュ': 'ｭ', 'ョ': 'ｮ', 'ッ': 'ｯ'
					'ー': 'ｰ'
					'ア': 'ｱ', 'イ': 'ｲ', 'ウ': 'ｳ', 'エ': 'ｴ', 'オ': 'ｵ'
					'カ': 'ｶ', 'キ': 'ｷ', 'ク': 'ｸ', 'ケ': 'ｹ', 'コ': 'ｺ'
					'サ': 'ｻ', 'シ': 'ｼ', 'ス': 'ｽ', 'セ': 'ｾ', 'ソ': 'ｿ'
					'タ': 'ﾀ', 'チ': 'ﾁ', 'ツ': 'ﾂ', 'テ': 'ﾃ', 'ト': 'ﾄ'
					'ナ': 'ﾅ', 'ニ': 'ﾆ', 'ヌ': 'ﾇ', 'ネ': 'ﾈ', 'ノ': 'ﾉ'
					'ハ': 'ﾊ', 'ヒ': 'ﾋ', 'フ': 'ﾌ', 'ヘ': 'ﾍ', 'ホ': 'ﾎ'
					'マ': 'ﾏ', 'ミ': 'ﾐ', 'ム': 'ﾑ', 'メ': 'ﾒ', 'モ': 'ﾓ'
					'ヤ': 'ﾔ', 'ユ': 'ﾕ', 'ヨ': 'ﾖ'
					'ラ': 'ﾗ', 'リ': 'ﾘ', 'ル': 'ﾙ', 'レ': 'ﾚ', 'ロ': 'ﾛ'
					'ワ': 'ﾜ', 'ン': 'ﾝ', 'ヰ': 'ｲ', 'ヱ': 'ｴ', 'ヲ': 'ｦ'
					'ガ': 'ｶﾞ', 'ギ': 'ｷﾞ', 'グ': 'ｸﾞ', 'ゲ': 'ｹﾞ', 'ゴ': 'ｺﾞ'
					'ザ': 'ｻﾞ', 'ジ': 'ｼﾞ', 'ズ': 'ｽﾞ', 'ゼ': 'ｾﾞ', 'ゾ': 'ｿﾞ'
					'ダ': 'ﾀﾞ', 'ヂ': 'ﾁﾞ', 'ヅ': 'ﾂﾞ', 'デ': 'ﾃﾞ', 'ド': 'ﾄﾞ'
					'バ': 'ﾊﾞ', 'ビ': 'ﾋﾞ', 'ブ': 'ﾌﾞ', 'ベ': 'ﾍﾞ', 'ボ': 'ﾎﾞ'
					'パ': 'ﾊﾟ', 'ピ': 'ﾋﾟ', 'プ': 'ﾌﾟ', 'ペ': 'ﾍﾟ', 'ポ': 'ﾎﾟ'
					'ヷ': 'ﾜﾞ', 'ヸ': 'ｲﾞ', 'ヹ': 'ｴﾞ', 'ヺ': 'ｦﾞ'
		# 全角カタカナへ
		toWideKatakana: ->
			@replace
				# 文字数の多い方を優先
				'ｶﾞ': 'ガ', 'ｷﾞ': 'ギ', 'ｸﾞ': 'グ', 'ｹﾞ': 'ゲ', 'ｺﾞ': 'ゴ'
				'ｻﾞ': 'ザ', 'ｼﾞ': 'ジ', 'ｽﾞ': 'ズ', 'ｾﾞ': 'ゼ', 'ｿﾞ': 'ゾ'
				'ﾀﾞ': 'ダ', 'ﾁﾞ': 'ヂ', 'ﾂﾞ': 'ヅ', 'ﾃﾞ': 'デ', 'ﾄﾞ': 'ド'
				'ﾊﾞ': 'バ', 'ﾋﾞ': 'ビ', 'ﾌﾞ': 'ブ', 'ﾍﾞ': 'ベ', 'ﾎﾞ': 'ボ'
				'ﾊﾟ': 'パ', 'ﾋﾟ': 'ピ', 'ﾌﾟ': 'プ', 'ﾍﾟ': 'ペ', 'ﾎﾟ': 'ポ'
				'ﾜﾞ': 'ヷ', 'ｲﾞ': 'ヸ', 'ｳﾞ': 'ヴ', 'ｴﾞ': 'ヹ', 'ｦﾞ': 'ヺ'
				'ﾞ': '゛', 'ﾟ': '゜'
				'ｧ': 'ァ', 'ｨ': 'ィ', 'ｩ': 'ゥ', 'ｪ': 'ェ', 'ｫ': 'ォ', 'ｬ': 'ャ'
				'ｭ': 'ュ', 'ｮ': 'ョ', 'ｯ': 'ッ'
				'ｰ': 'ー'
				'ｱ': 'ア', 'ｲ': 'イ', 'ｳ': 'ウ', 'ｴ': 'エ', 'ｵ': 'オ'
				'ｶ': 'カ', 'ｷ': 'キ', 'ｸ': 'ク', 'ｹ': 'ケ', 'ｺ': 'コ'
				'ｻ': 'サ', 'ｼ': 'シ', 'ｽ': 'ス', 'ｾ': 'セ', 'ｿ': 'ソ'
				'ﾀ': 'タ', 'ﾁ': 'チ', 'ﾂ': 'ツ', 'ﾃ': 'テ', 'ﾄ': 'ト'
				'ﾅ': 'ナ', 'ﾆ': 'ニ', 'ﾇ': 'ヌ', 'ﾈ': 'ネ', 'ﾉ': 'ノ'
				'ﾊ': 'ハ', 'ﾋ': 'ヒ', 'ﾌ': 'フ', 'ﾍ': 'ヘ', 'ﾎ': 'ホ'
				'ﾏ': 'マ', 'ﾐ': 'ミ', 'ﾑ': 'ム', 'ﾒ': 'メ', 'ﾓ': 'モ'
				'ﾔ': 'ヤ', 'ﾕ': 'ユ', 'ﾖ': 'ヨ'
				'ﾗ': 'ラ', 'ﾘ': 'リ', 'ﾙ': 'ル', 'ﾚ': 'レ', 'ﾛ': 'ロ'
				'ﾜ': 'ワ', 'ﾝ': 'ン', 'ｦ': 'ヲ'
				# ヰヱの半角は存在しないので対象外
		toNarrowJapneseSymbol: ->
			@replace
				'。': '｡'
				'「': '｢'
				'」': '｣'
				'、': '､'
				'・': '･'
		toWideJapneseSymbol: ->
			@replace
				'｡': '。'
				'｢': '「'
				'｣': '」'
				'､': '、'
				'･': '・'
		toNarrowJapnese: ->
			@
				.toNarrowKatakana()
				.toNarrowJapneseSymbol()
		toWideJapnese: ->
			@
				.toWideKatakana()
				.toWideJapneseSymbol()
		toNarrow: (japaneseChars = false) ->
			res = @replace _rIncluded([SPACE_LIKE_CHARS]), ' ' # スペース類 -> 半角スペース
			hash = {}
			hash[FULLWIDTH_ALPHANUMERIC_CHARS_WITH_SIGN] = -65248
			res = res.shift hash
			if japaneseChars # カタカナや記号を半角にするかどうか
				res = res.toNarrowJapnese()
			res
		toWide: ->
			res = @replace(' ', '\u3000') # 半角スペース -> 全角スペース
			hash = {}
			hash[ALPHANUMERIC_CHARS_WITH_SIGN] = +65248
			@
				.toWideJapnese()
				.shift hash
		toNumber: ->
			parseFloat @
				.toNarrow()
				.remove(',')
		toCode: (digit, inAlpha, inHyphen) ->
			char = DIGIT_CAHRS
			char += ALPHA_CHARS if inAlpha
			char += '-' if inHyphen
			res = @toNarrow().remove new RegExp "[^#{char}]", 'g'
			if digit
				while res.getLength() < digit
					res = res.add 0
			res
		toBool: ->
			!!@_
		toArray: ->
			@_.split ''
		toCharCodeArray: ->
			chars = @toArray()
			for char, i in chars
				chars[i] = '\\u' + char.charCodeAt(0).toString(16)
			chars
		toCharCode: ->
			@toCharCodeArray.join ''
		isOnlyHiragana: (withSpace) ->
			@isOnly HIRAGANA_CHARS, KANA_COMMON_CAHRS, if withSpace then SPACE_LIKE_CHARS else ''
		isOnlyKatakana: (withSpace) ->
			@isOnly KATAKANA_CHARS, KANA_COMMON_CAHRS, if withSpace then SPACE_LIKE_CHARS else ''
		isOnlyAlphabet: (withSpace) ->
			@isOnly ALPHA_CHARS, if withSpace then SPACE_LIKE_CHARS else ''
		isUnsignedInterger: ->
			@isOnly DIGIT_CAHRS
		isEMail: ->
			# 参考: http://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%BC%E3%83%AB%E3%82%A2%E3%83%89%E3%83%AC%E3%82%B9
			# メールアドレスの文字列長は合計256文字まで
			if @getLength() > 256
				return false
			# ローカル部とドメイン部を分ける
			# @はquoted-string内で出現する可能性があるのでドメイン部を基準に考える(@でスプリットをする方法はしない)
			patternMail = ///
				^ # 先頭
				( # ローカル部
					[0-9a-z\.!\#$%&'*+\-/=?^_`{|}~\(\)<>\[\]:;@,"\\\u0020]+ # ローカル部で利用可能な文字(正確な検証は後で)
				)
				@ # アットマーク区切り
				( # ドメイン部分(マッチグループに保存)
					(?: # サブドメイン
						[0-9a-z] # ドメイン部の先頭
						[0-9a-z-]* # ドメイン部の2文字目以降
						\. # ドット
					)+
					# トップレベルドメイン
					[0-9a-z]{2,6} # 2文字以上6文字以下
					|
					\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\] # IPアドレス
				)
				$ # 末尾
				///i # 大文字と小文字を区別しない
			mailMatch = @match patternMail
			unless mailMatch
				return false
			local = mailMatch[1]
			domain = mailMatch[2]
			# ドメイン部の文字列長は255文字まで
			if domain.length > 255
				return false
			# ローカル部の文字列長は64文字まで
			if local.length > 64
				return false
			patternQuoted = ///
				^" # 先頭クオート
				.+ # 最小マッチ
				"$ # 末尾クオート
			///g
			isQuoted = patternQuoted.test local
			# console.log local
			if isQuoted # quoted-stringの場合
				local = local.replace /^"|"$/g, '' # 先頭末尾のクオートを削除
				patternEscapedBadChars = /// # エスケープされたクオートとバックスラッシュ
					\\"
					|
					\\\\
				///g
				patternBadChars = ///
					"
					|
					\\
				///
				# エスケープされたクオートとバックスラッシュを取り除き、その上でクオートとバックスラッシュがある場合は偽をとする
				escaped = local.replace patternEscapedBadChars, ''
				if patternBadChars.test escaped
					return false
				return true
			# 禁止のドット
			patternBadDot = ///
				^\. # ドットで始まる
				|
				\.{2,} # ドットが2個以上連続する
				|
				\.$ # ドットで終わる
			///i
			if patternBadDot.test local
				return false
			# quoted-stringではないローカル部で許可される文字
			patternlocalNonQuoteds = /^[0-9a-z\.!#$%&'*+\-\/=?^_`{|}~]+$/i
			unless patternlocalNonQuoteds.test local
				return false
			return true

	class CustomRule
		# ----- ----- ----- ----- ----- # Instance Member
		isGroupRule: false
		_cast: null
		_valid: null
		# ----- ----- ----- ----- ----- # Private Method
		_toVString = (values) ->
			# log values
			if $.isPlainObject values
				for key, value of values
					values[key] = new VString value
			else
				values = new VString values
			return values
		_optimizeValue = (value, ruleMaster) ->
			if /^:/.test value
				value = ruleMaster?.getValue value.replace /^:/, ''
			return value
		_optimizeValues = (values, ruleMaster) ->
			res = []
			for value in values
				res.push _optimizeValue value, ruleMaster
			return res
		_optimize = (value, ruleMaster) ->
			if $.isPlainObject value
				for key, val of value
					value[key] = _optimizeValues val, ruleMaster
			else
				value = _optimizeValues value, ruleMaster
			return value
		# ----- ----- ----- ----- ----- # Instance Method
		constructor: (options) ->
			if $.isPlainObject options
				@isGroupRule = options.isGroupRule or false
				@_cast = options.cast or null
				@_valid = options.valid or null
				unless $.isFunction @_valid
					@error()
			else
				@error()
		error: ->
			throw new Error 'Couldn\'t create instance of CustomRule because Invalid argument given.' # 無効な引数が渡されたため、インスタンスを作成できませんでした。
		cast: (element, values, args = [], ruleMaster) ->
			values = _toVString values
			args = _optimize args, ruleMaster
			if $.isFunction @_cast
				values = @_cast.apply element, [values, args]
			# log values
			return values
		valid: (element, values, args = [], ruleMaster) ->
			# log element, values, args, ruleMaster
			values =  _toVString values
			args = _optimize args, ruleMaster
			# log values, args
			@_valid.apply element, [values, args]

	class Validation
		@customRules:
			length: new CustomRule
				cast: (value) ->
					value.trim()
				valid: (value, length) ->
					if value.getLength() < length
						'文字数が足りません'
					else if value.getLength() > length
						'文字数がオーバーしています'
			hiragana: new CustomRule
				cast: (value) ->
					value.trim().toHiragana()
				valid: (value, args) ->
					withSpace = args[0] is 'true'
					unless value.isOnlyHiragana withSpace then '全角ひらがなで入力してください'
			katakana: new CustomRule
				cast: (value) ->
					value.trim().toKatakana()
				valid: (value, args) ->
					withSpace = args[0] is 'true'
					unless value.isOnlyKatakana withSpace then '全角カタカナで入力してください'
			alpha: new CustomRule
				cast: (value) ->
					value.trim().toNarrow()
				valid: (value) ->
					unless value.isOnlyAlphabet() then '半角アルファベットで入力してください'
			uint: new CustomRule
				cast: (value) ->
					value.trim().toNumber()
				valid: (value) ->
					unless value.isUnsignedInterger() then '半角数字を入力して下さい'
			char: new CustomRule
				cast: (value, query = []) ->
					value = value.trim()
					query = query.join ''
					hiragana = /あ|かな?|ひらがな/.test query
					katakana = /ア|(?:カタ)?カナ?/.test query
					unless hiragana and katakana
						if hiragana
							value = value.toHiragana()
						if katakana
							value = value.toKatakana()
					if /a|d|0|@|半角?(?:英|数|和|記)?/i.test query
						value = value.toNarrow()
					else if /ａ|Ａ|ｄ|Ｄ|０|＠|全角?/.test query
						value = value.toWide()
					if /ｱ|(?:ｶﾀ)?ｶﾅ?|半角?(?:カタ)?カナ?/.test query
						unless hiragana
							value = value.toKatakana()
						value = value.toNarrowJapnese()
					# log value, query
					value
				valid: (value, query = []) ->
					query = query.join ''
					out = []
					flag = 0
					if /半角?英数/.test query
						flag |= VString.ALPHANUMERIC
						out.push '半角英数'
					else
						if /a|半角?英字?/i.test query
							flag |= VString.ALPHABET
							out.push '半角英字'
						if /d|0|半角?数字?/i.test query
							flag |= VString.DIGIT
							out.push '半角数字'
					if /全角?英数/.test query
						flag |= VString.FULLWIDTH_ALPHANUMERIC
						out.push '全角英数'
					else
						if /ａ|Ａ|全角?英字?/.test query
							flag |= VString.FULLWIDTH_ALPHABET
							out.push '全角英字'
						if /ｄ|Ｄ|０|全角?数字?/.test query
							flag |= VString.FULLWIDTH_DIGIT
							out.push '全角数字'
					if /あ|かな?|ひらがな/.test query
						flag |= VString.HIRAGANA
						out.push '全角ひらがな'
					if /ｱ|(?:ｶﾀ)?ｶﾅ?|半角?(?:カタ)?カナ?/.test query
						flag |= VString.NARROW_KATAKANA
						out.push '半角カタカナ'
					else if /ア|(?:カタ)?カナ?/.test query
						flag |= VString.KATAKANA
						out.push '全角カタカナ'
					if /＠|全角?(?:英字?)?(?:数字?)?和?記号?/.test query
						flag |= VString.FULLWIDTH_SIGN | VString.JAPANESE_SIGN
						out.push '全角記号'
					else
						if /@|半角?(?:英字?)?(?:数字?)?和?記号?/.test query
							flag |= VString.SIGN
							out.push '半角記号'
					if /j|和記号?/i.test query
						flag |= VString.JAPANESE_SIGN
						out.push '和記号'
					if /-/.test query
						flag |= VString.HYPHEN
					# log flag, out
					unless value.isOnly flag then "#{out.join('/')}を入力してください"
			zenkaku: new CustomRule
				cast: (value) ->
					value.trim().toWide()
				valid: ->
					return
			notZero: new CustomRule
				cast: (value) ->
					value.trim().toNumber()
				valid: (value) ->
					if parseFloat(value) is 0 then '0 は受け付けられません'
			range: new CustomRule
				cast: (value) ->
					value.trim().toNumber()
				valid: (value, options = []) ->
					value = value.toNumber()
					min = options[0] or 0
					max = options[1] or Infinity
					step = options[2] or 1
					unit = options[3] or '' # 単位
					unless min <= value <= max
						return if max is Infinity then "#{min}#{unit} 以上を入力してください" else "#{min}#{unit} から #{max}#{unit} を入力してください"
					if value % step
						return "#{step}#{unit} 単位で入力してください"
			codeNum: new CustomRule
				cast: (value, args) ->
					# log value, args
					digit = parseInt(args[0], 10)
					inAlpha = args[1] is 'true' or args[1] is true
					inHyphen = args[2] is 'true' or args[2] is true
					value.toCode digit, inAlpha, inHyphen
				valid: (value, args) ->
					digit = parseInt(args[0], 10) or 1
					inAlpha = args[1] is 'true' or args[1] is true
					inHyphen = args[2] is 'true' or args[2] is true
					option = DIGIT_CAHRS
					error = ['半角数字']
					if inAlpha
						option += ALPHA_CHARS
						error = ['半角英数']
					if inHyphen
						option += '-'
						error.push 'ハイフン'
					unless value.isOnly option then "#{error.join('/')}を入力してください"
			mail: new CustomRule
				isGroupRule: true
				cast: (value) ->
					if $.isPlainObject value
						# console.log value.local, value.domain
						value.local = value.local.trim().toNarrow()
						value.domain = value.domain.trim().toNarrow()
						return value
					else
						return value.trim()
				valid: (value) ->
					# log value
					if $.isPlainObject value
						# console.log value.local, value.domain
						value = value.local.concat '@', value.domain
					unless value.isEMail() then 'メールアドレスの形式が間違っています'
			date: new CustomRule
				isGroupRule: true
				valid: (values, options) ->
					# log values, options
					$form = $(@year).parents('form')
					gengo = values.gengo?.toString()
					year = values.year?.toNumber()
					month = values.month?.toNumber()
					date = values.date?.toNumber()
					isAgeCheck = !!options?.age
					ageLimits = if isAgeCheck then options.age[0] else Infinity
					$age = $ @age
					$elapsedYear = $ @elapsedYear
					$elapsedMonth = $ @elapsedMonth
					if gengo
						# log gengo, year, month, date, fullYear, isAgeCheck, ageLimits
						if isNaN month # 年だけパターン
							if rangeError = checkGengo gengo, year
								if rangeError.end?
									return "#{gengo} は #{rangeError.end.year} 年までです"
							month = 1
						else if isNaN date # 年+月パターン
							if rangeError = checkGengo gengo, year, month
								if rangeError.end?
									return "#{gengo} は #{rangeError.end.year} 年 #{rangeError.end.month} 月までです"
								else if rangeError.start?
									return "#{gengo} は #{rangeError.start.month} 月からです"
							date = 1
						else
							if rangeError = checkGengo gengo, year, month, date
								if rangeError.end?
									return "#{gengo} は #{rangeError.end.year} 年 #{rangeError.end.month} 月 #{rangeError.end.date} 日までです"
								else if rangeError.start?
									return "#{gengo} は #{rangeError.start.month} 月 #{rangeError.start.date} 日からです"
						fullYear = w2s(year, gengo)
					else
						fullYear = year
						month = 1 if isNaN month
						date = 1 if isNaN date
					thedate = new Date(fullYear, month - 1, date, 0 ,0 ,0, 0)
					# 日付が妥当か
					unless 1 <= month <= 12
						return "#{month} 月はありません"
					unless date is thedate.getDate()
						return "#{year} 年 #{month} 月に #{date} 日はありません"
					today = new Date()
					today.setHours 0
					today.setMinutes 0
					today.setSeconds 0
					today.setMilliseconds 0
					age = today.getFullYear() - thedate.getFullYear()
					if today.getMonth() <= thedate.getMonth() and today.getDate() < thedate.getDate()
						age -= 1
					elapsedYear = age
					elapsedMonth = today.getMonth() - thedate.getMonth()
					if today.getDate() < thedate.getDate()
						elapsedMonth -= 1
					if elapsedMonth < 0
						elapsedMonth = 12 + elapsedMonth
						age = elapsedYear -= 1
					data =
						gengo: gengo
						year: fullYear
						month: month
						date: date
						age: age
						thedate: thedate
						today: today
						elapsedYear: elapsedYear
						elapsedMonth: elapsedMonth
					# log data
					$form.trigger 'validation.date', data # 計算結果をイベントで受け取れるようにする。
					if isAgeCheck
						$age.val age # 年齢を出力
						if ageLimits and age < ageLimits
							$age.val ''
							return "#{ageLimits} 歳以上の方しかお申込みできません"
					if age < 0 # 日付が未来の場合
						$age.val ''
						return "未来の日付です"
					$elapsedYear.val elapsedYear
					$elapsedMonth.val elapsedMonth
					# エラーなし
					return

	class RuleMaster
		# ----- ----- ----- ----- ----- # Instance Member
		form: null
		debug: off
		rules: null
		onShowMessage: null
		onValidateEnd: null
		# ----- ----- ----- ----- ----- # Instance Method
		constructor: ($form, rules, onShowMessage, onValidateEnd) ->
			groups = {}
			@rules = {}
			for ruleName, rule of rules
				$elem = $ "[name='#{ruleName}']"
				unless $elem.length then continue # 要素がなければ登録しない
				elem = $elem[0]
				type = elem.type
				switch type.toLowerCase()
					when 'hidden', 'submit', 'button', 'image' # これらがtypeの要素は登録しない
						continue
				groupMatch = rule.match /group:([^\s]+)(?:\s+|$)/i
				if groupMatch
					groupName = groupMatch[1]
					unless groups[groupName]?
						groups[groupName] = []
					groups[groupName].push new Rule ruleName, rule, $elem, @, groupName
				else
					@rules[ruleName] = new Rule ruleName, rule, $elem, @
			for groupName, rules of groups
				@rules[groupName] = new RuleGroup groupName, rules, @
			log $elem
			@form = $form[0]
			@onShowMessage = onShowMessage or showMessage
			@onValidateEnd = onValidateEnd or validateEnd
		getRule: (name) ->
			for ruleName, rule of @rules
				# log ruleName, rule
				if rule instanceof Rule
					if name is ruleName
						return rule
				if rule instanceof RuleGroup
					cRule = rule.getRule name
					if cRule
						return cRule
			return null
		getValue: (name, typeofVString) ->
			rule = @getRule name
			if rule
				res = rule.getValue()
				if typeofVString
					res = new VString res
			res
		validate: ->
			error = false
			messages = {}
			messagesArray = []
			for ruleName, rule of @rules
				message = rule.validate()
				log(ruleName, message) if @debug
				messages[ruleName] = message
				messagesArray.push message
				if message
					error = true
			@onValidateEnd.call @form, !error, messages, messagesArray
			return !error

	class RuleGroup
		# ----- ----- ----- ----- ----- # Instance Member
		name: ''
		length: 0
		$elem: null
		groupRules: null
		requireRule: null
		master: null
		# ----- ----- ----- ----- ----- # Instance Method
		constructor: (groupName, rules, master) ->
			# log rules
			@name = groupName
			@$elem = $()
			@groupRules = {}
			@master = master
			for rule, i in rules
				name = rule.name
				@$elem = $.merge @$elem, rule.$elem
				for inRule in rule.rules
					inName = inRule.name
					isGroupRule = inRule.method.isGroupRule
					if isGroupRule
						# log @name, name, inName, inRule
						unless @groupRules[inName]?
							@groupRules[inName] = {}
						label = rule.groupLabel = inRule.label or name
						@groupRules[inName][label] = inRule.params
				unless @requireRule
					if rule.groupRequireRule
						@requireRule = rule.groupRequireRule
				@[i] = rule
			@length = i
		getRule: (name) ->
			for rule in @
				if name is rule.name
					return rule
			return null
		each: (callback) ->
			for i, rule of @
				if isFinite i
					callback.call rule, parseInt(i, 10)
			return
		empty: ->
			res = true
			@each ->
				unless @empty()
					res = false
			return res
		getValues: ->
			res = {}
			@each ->
				if @groupLabel
					res[@groupLabel] = @getValue()
				else
					res[@name] = @getValue()
				return
			# log 'values', res
			return res
		getElements: ->
			res = {}
			@each ->
				if @groupLabel
					res[@groupLabel] = @$elem[0]
				else
					res[@name] = @$elem[0]
				return
			return res
		check: ->
			toGroupCheck = false
			errorMessage = ''
			elems = @getElements()
			values = @getValues()
			# まずグループ専用の必須チェックがあればかける
			if @requireRule?
				customRule = Validation.customRules[@requireRule.name]
				castedValues = customRule.cast elems, values, @requireRule.params, @master
				errorMessage = customRule.valid elems, castedValues, @requireRule.params, @master
				if errorMessage # エラーがあった場合はそこでメッセージを返す
					return errorMessage
			# 次に個別ルールの必須&空欄チェックを行う
			@each ->
				unless toGroupCheck # グループルールチェックへのフラグたったらもうチェックしない
					if @require
						toGroupCheck = true
						return
					unless @empty()
						toGroupCheck = true
						return
			if toGroupCheck
				# グループルールがある場合はここでチェック
				for groupRuleName, groupRule of @groupRules
					# log @, groupRuleName, groupRule
					customRule = Validation.customRules[groupRuleName]
					castedValues = customRule.cast elems, values, groupRule, @master
					# log @, groupRuleName, castedValues, elems
					errorMessage = customRule.valid elems, castedValues, groupRule, @master
					# log 'GroupError:' + groupRuleName, errorMessage
					if errorMessage # エラーがあった場合はそこでメッセージを返す
						return errorMessage
				# グループルールのエラーがなければ個別チェックをかける
				unless errorMessage
					@each ->
						unless errorMessage # エラーが既に出ていればもうチェックしない
							errorMessage = @check()
			return errorMessage
		validate: ->
			errorMessage = @check()
			return @[0].message !errorMessage, errorMessage

	class Rule
		# ----- ----- ----- ----- ----- # Instance Member
		master: null
		name: ''
		groupName: null
		groupLabel: ''
		ruleQuery: ''
		type: null
		$elem: null
		require: false
		requireRule: null
		groupRequireRule: null
		callback: []
		rules: []
		ignore: []
		# ----- ----- ----- ----- ----- # Instance Method
		constructor: (ruleName, rule, $elem, master, groupName) ->
			rulesQuerySplit = rule.split /\s+/
			rules = []
			require = false
			ignore = []
			callback = []
			for rulesQuery in rulesQuerySplit
				unless rulesQuery
					continue
				key = rulesQuery.match(/^[^:\(\)@,]+/)[0]
				label = rulesQuery.match(/^[^:\(\)@,]+:([^:\(\)@,]+)/)?[1]
				valueStrings = rulesQuery.match(/^[^\(\)@,]+\(([^\(\)]+)\)/)?[1]
				values = valueStrings?.split(',') or []
				# log ruleName, rulesQuery, key, label, valueStrings, values
				switch key.toLowerCase()
					when 'require'
						if label
							log 'require:', label, values
							if Validation.customRules[label]?
								if groupName
									groupRequireRule =
										name: label
										params: values
								else
									requireRule =
										name: label
										params: values
								# log groupName, requireRule
							else
								warn "CustomRule(RequireGroupRule) #{label} is not defined."
						else
							require = true
					when 'ignore'
						ignore = values
					when 'call'
						callback.push label
					when 'group'
					else
						# log ruleName, rulesQuery, key, label, values, valueStrings
						method = Validation.customRules[key]
						if method?
							rules.push
								name: key
								label: label
								params: values
								method: method
						else # 指定されたルールのメソッドが定義されてない場合、警告する
							warn "CustomRule #{key} is not defined."
			@master = master
			@name = ruleName
			@ruleQuery = rule
			@type = $elem[0].type
			@$elem = $elem
			@require = require
			@requireRule = requireRule
			@rules = rules
			@ignore = ignore
			@groupName = groupName or null
			@groupRequireRule = groupRequireRule or null
			@callback = callback
		getValue: ->
			value = @$elem.val()
			# log "#{@name}: #{value}"
			switch @type
				when 'select-one'
					for ignore in @ignore
						if value is ignore
							return null
					return value
				when 'checkbox', 'radio'
					return @$elem.filter(':checked').val() or null
				else
					return value
		empty: ->
			value = @getValue()
			return !value
		message: (passed, message) ->
			@master.onShowMessage.call @$elem[0], passed, message
			return message
		check: ->
			value = @getValue()
			castedValue = value
			elem = @$elem[0]
			if @requireRule?
				# console.log @requireRule.params.join()
				method = Validation.customRules[@requireRule.name]
				castedValue = method.cast elem, castedValue, @requireRule.params, @master
				errorMessage = method.valid elem, castedValue, @requireRule.params, @master
				if errorMessage
					return errorMessage
			if @require
				if @empty()
					return '必須項目です'
			else
				# log "#{@name} 必須じゃないです。@emptyは", @empty()
				if @empty()
					return ''
			for rule in @rules
				method = Validation.customRules[rule.name]
				if method
					# log rule.name, method
					if method.isGroupRule and @groupName
						# log 'toGroup'
						continue # グループルールの場合はここで個別チェックはせず、グループ単位で行う
					castedValue = method.cast elem, castedValue, rule.params, @master
					errorMessage = method.valid elem, castedValue, rule.params, @master
					# log 'ValidError:' + rule.name, errorMessage
					if errorMessage
						return errorMessage
			# キャストした値の反映
			unless /select|checkbox|radio/i.test @type # typeが左のものに該当しなければ反映
				@$elem.val castedValue
			return ''
		validate: (isGroupCheck) ->
			if isGroupCheck and @groupName
				# log @master, @groupName
				return @master.rules[@groupName].validate()
			errorMessage = @check()
			for callback in @callback
				@master.rules[callback]?.validate()
			return @message !errorMessage, errorMessage

	$.fn.validation = (rulesOrMethod, customRules, onShowMessage, onValidateEnd) ->
		# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- # Variables #
		$elem = @.eq 0
		elem = $elem[0]
		# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- # Execute #
		# Form要素出ない場合はなにもしない
		unless elem then return @
		unless elem.nodeName.toLowerCase() is 'form' then return @
		# インスタンス化チェック
		rules = $elem.data 'validation'
		# メソッド実行
		if rules
			methodName = String(rulesOrMethod).toLowerCase()
			# log methodName
			switch methodName
				when 'validate'
					rules.validate()
				when 'getrules'
					return rules
		# インスタンス化
		else
			# カスタムルールを追加する
			if $.isPlainObject customRules
				for customRuleName, customRuleOption of customRules
					# log customRuleOption
					if Validation.customRules[customRuleName]
						if customRuleOption.valid
							Validation.customRules[customRuleName]._valid = customRuleOption.valid
						if customRuleOption.cast
							Validation.customRules[customRuleName]._cast = customRuleOption.cast
					else
						Validation.customRules[customRuleName] = new CustomRule customRuleOption
			# ルールインスタンスを生成
			rules = new RuleMaster @, rulesOrMethod, onShowMessage, onValidateEnd
			rules.debug = DEBUG_MODE # デバッグモード
			# インスタンス化フラグ
			$elem.data 'validation', rules
			# イベント登録
			$elem.submit (e, data) ->
				if data?.noValidate
					return on
				return rules.validate()
			$elem.on 'blur change', 'input, select, textarea', ->
				$this = $ @
				name = @name
				type = @type
				# log arguments[0].type, name, $this
				switch type.toLowerCase()
					when 'hidden', 'submit', 'button', 'image' # これらがtypeの要素は無視
					else # 上記以外はバリデーション実行
						rule = rules.getRule name
						# log name, rules
						rule.validate true
				# falseを返す意味はない。
				# falseを返していまうとIE8, IE9-10互換モード等でラジオボタン・チェックボックスがチェックできなくなる。
				return true
			# Debug
			log rules if DEBUG_MODE
		return @

	# 暫定のデフォルト表示処理
	# その都度いつでもオーバーライドできる
	showMessage = (passed, message) ->
		$this = $ @
		$tr = $this.parents('tr')
		$td = $tr.find('td.check')
		$ok = $td.find('.ok')
		$ng = $td.find('.form_ng')
		if passed
			$tr.removeClass 'error'
			$ok.show()
			$ng.hide()
		else
			$tr.addClass 'error'
			$ok.hide()
			$ng.show().text message
		return passed

	# 暫定のデフォルトチェック後処理
	# その都度いつでもオーバーライドできる
	validateEnd = (passed, messages, messagesArray) ->
		# log @, passed, messages, messagesArray
		unless passed
			top = $(@).find('.error').eq(0).offset().top
			$('html,body').animate scrollTop: top, 600

	# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- # デバッグ用関数 #
	if typeof console isnt 'undefined' and typeof console.log is 'object'
		do ->
			slice = Array::slice
			bind = Function::bind or (context) ->
				args = slice.call arguments, 1
				self = this
				return ->
					self.apply context, args.concat slice.call arguments
			methods = ['log', 'info', 'warn', 'error', 'assert', 'dir', 'clear', 'profile', 'profileEnd']
			for method in methods
				console[method] = bind.call(Function::call, console[method], console)
			return
	log = ->
		console?.log?.apply console, [log.i++].concat $.makeArray arguments
		arguments
	log.i = 0

	# log = do -> console.log.bind console # 行番号を表示させる場合

	warn = ->
		console?.warn?.apply console, arguments
		arguments

	# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- # ネームスペースにクラスを追加 #
	# グローバルスコープでは
	# jQuery.Validation
	# jQuery.Validation.String
	# 以上のコンストラクタが使用可能
	Validation.String = VString
	$.Validation = Validation

	return