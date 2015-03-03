d = document

p = (v, br) ->
	brTag = if br then '<br>' else ''
	d.write v + brTag

t = (tag, v, klass = null) ->
	klassTag = if klass? then " class=\"#{klass}\"" else ''
	p "<#{tag}#{klassTag}>#{v}</#{tag}>"

th = (v, klass) ->
	t 'th', v, klass

td = (v, klass) ->
	t 'td', v, klass

put = (calls) ->
	p '<table>'
	p '<tr>'
	th '処理'
	td '期待値'
	td '結果'
	p '</tr>'
	for exec, ideal of calls
		res = eval exec
		p '<tr>'
		th exec.replace('\\\\', '\\') # エスケープの除去
		td ideal
		td res, res is ideal
		p '</tr>'
	p '</table>'

`window.Rules = jQuery.Validation.customRules`
`window.VString = jQuery.Validation.String`
p 'var Rules = jQuery.Validation.customRules;', on
p 'var VString = jQuery.Validation.String;', on
p 'と定義しているとする'

put
	"Rules.length.valid(document, '0123456789abcdef', [16])": undefined
	"Rules.length.valid(document, '0123456789abcdefg', [16])": '文字数がオーバーしています'
	"Rules.length.valid(document, '0123456789abcde', [16])": '文字数が足りません'
	"Rules.hiragana.valid(document, 'あいうえお')": undefined
	"Rules.hiragana.valid(document, 'わ゙ゐ゙ゔゑ゙を゙゛゜ー')": undefined
	"Rules.hiragana.valid(document, 'あ丂ウエABCｘｙｚ０１２0789')": '全角ひらがなで入力してください'
	"Rules.katakana.valid(document, 'アイウエオ')": undefined
	"Rules.katakana.valid(document, 'ヷヸヴヹヺ゛゜ー')": undefined
	"Rules.katakana.valid(document, 'あ丂ウエABCｘｙｚ０１２0789')": '全角カタカナで入力してください'
	"Rules.alpha.valid(document, 'ABCxyz')": undefined
	"Rules.alpha.valid(document, 'ＡＢＣｘｙｚ')": '半角アルファベットで入力してください'
	"Rules.alpha.valid(document, 'あ丂ウエABCｘｙｚ０１２0789')": '半角アルファベットで入力してください'
	"Rules.uint.valid(document, '0123456789')": undefined
	"Rules.uint.valid(document, '-256')": '0 以上を入力して下さい'
	"Rules.uint.valid(document, '3.141592')": '半角数字を入力して下さい'
	"Rules.uint.valid(document, '０１２３４５６７８９')": '半角数字を入力して下さい'
	"Rules.uint.valid(document, 'あ丂ウエABCｘｙｚ０１２0789')": '半角数字を入力して下さい'
	"Rules.notZero.valid(document, '0')": '0 は受け付けられません'
	"Rules.notZero.valid(document, '000')": '0 は受け付けられません'
	"Rules.notZero.valid(document, '012')": undefined
	"Rules.range.valid(document, '355')": undefined
	"Rules.range.valid(document, '355', [0, 500])": undefined
	"Rules.range.valid(document, '355', [200, 300])": '200 から 300 を入力してください'
	"Rules.range.valid(document, '355', [1000, 2000])": '1000 から 2000 を入力してください'
	"Rules.range.valid(document, '355', [100, 500, 5])": undefined
	"Rules.range.valid(document, '355', [100, 500, 10])": '10 単位で入力してください'
	"Rules.mail.valid(document, 'hirao@d-public.net')": undefined
	"Rules.mail.valid(document, 'hirao(at)d-public.net')": 'メールアドレスの形式が間違っています'
	"Rules.mail.valid(document, 'ｈｉｒａｏ＠ｄ－ｐｕｂｌｉｃ．ｎｅｔ')": 'メールアドレスの形式が間違っています'
	"Rules.mail.valid(document, 'Abc@example.com')": undefined
	"Rules.mail.valid(document, 'Abc@example.comcomcom')": 'メールアドレスの形式が間違っています'
	"Rules.mail.valid(document, 'Abc@[192.168.0.1]')": undefined
	"Rules.mail.valid(document, 'Abc.123@example.com')": undefined
	"Rules.mail.valid(document, 'user+mailbox/department=shipping@example.com')": undefined
	"Rules.mail.valid(document, '!#$%&*+-/=?^_`.{|}~@example.com')": undefined
	"Rules.mail.valid(document, '\"Abc@def\"asdfasdf\"zzz@234\"@example.com')": 'メールアドレスの形式が間違っています'
	"Rules.mail.valid(document, '\"Fred Bloggs\"@example.com')": undefined
	"Rules.mail.valid(document, '\"Joe.\\\\\"Blow\"@example.com')": undefined
	"Rules.mail.valid(document, '\"John.\\\\\"Smith@example.com')": 'メールアドレスの形式が間違っています'
	"Rules.mail.valid(document, '\"Mr..........Red\"@example.com')": undefined
	"Rules.mail.valid(document, 'Abc.@example.com')": 'メールアドレスの形式が間違っています'
	"Rules.mail.valid(document, '012345670123456701234567012345670123456701234567012345670123456701234567@example.com')": 'メールアドレスの形式が間違っています'
	"Rules.mail.valid(document, { local: 'hirao', domain: 'd-public.net' })": undefined
	"Rules.mail.valid(document, { local: 'hi..rao', domain: 'd-public.net' })": 'メールアドレスの形式が間違っています'
	"Rules.char.valid(document, 'abcABC012', ['半角英数'])": undefined
	"Rules.char.valid(document, 'abcABC012', ['半英数'])": undefined
	"Rules.char.valid(document, 'abcABC', ['a'])": undefined
	"Rules.char.valid(document, 'abcABC', ['A'])": undefined
	"Rules.char.valid(document, 'abcABC', ['半角英字'])": undefined
	"Rules.char.valid(document, 'abcABC', ['半英字'])": undefined
	"Rules.char.valid(document, 'abcABC', ['半角英'])": undefined
	"Rules.char.valid(document, 'abcABC', ['半英'])": undefined
	"Rules.char.valid(document, '0123456', ['d'])": undefined
	"Rules.char.valid(document, '0123456', ['D'])": undefined
	"Rules.char.valid(document, '0123456', ['0'])": undefined
	"Rules.char.valid(document, '0123456', ['半角数字'])": undefined
	"Rules.char.valid(document, '0123456', ['半数字'])": undefined
	"Rules.char.valid(document, '0123456', ['半角数'])": undefined
	"Rules.char.valid(document, '0123456', ['半数'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ０１２３', ['全角英数'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ０１２３', ['全英数'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ', ['ａ'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ', ['Ａ'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ', ['全角英字'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ', ['全英字'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ', ['全角英'])": undefined
	"Rules.char.valid(document, 'ａｂｃＡＢＣ', ['全英'])": undefined
	"Rules.char.valid(document, '０１２３４５６', ['ｄ'])": undefined
	"Rules.char.valid(document, '０１２３４５６', ['Ｄ'])": undefined
	"Rules.char.valid(document, '０１２３４５６', ['０'])": undefined
	"Rules.char.valid(document, '０１２３４５６', ['全角数字'])": undefined
	"Rules.char.valid(document, '０１２３４５６', ['全数字'])": undefined
	"Rules.char.valid(document, '０１２３４５６', ['全角数'])": undefined
	"Rules.char.valid(document, '０１２３４５６', ['全数'])": undefined
	"Rules.char.valid(document, 'あいうえお', ['あ'])": undefined
	"Rules.char.valid(document, 'あいうえお', ['か'])": undefined
	"Rules.char.valid(document, 'あいうえお', ['かな'])": undefined
	"Rules.char.valid(document, 'あいうえお', ['ひらがな'])": undefined
	"Rules.char.valid(document, 'アイウエオ', ['ア'])": undefined
	"Rules.char.valid(document, 'アイウエオ', ['カ'])": undefined
	"Rules.char.valid(document, 'アイウエオ', ['カナ'])": undefined
	"Rules.char.valid(document, 'アイウエオ', ['カタカナ'])": undefined
	"Rules.char.valid(document, '#$%&', ['@'])": undefined
	"Rules.char.valid(document, '#$%&', ['半角記号'])": undefined
	"Rules.char.valid(document, '#$%&', ['半記号'])": undefined
	"Rules.char.valid(document, '#$%&', ['半記'])": undefined
	"Rules.char.valid(document, '＃＄％＆。「」、', ['＠'])": undefined
	"Rules.char.valid(document, '＃＄％＆。「」、', ['全角記号'])": undefined
	"Rules.char.valid(document, '＃＄％＆。「」、', ['全記号'])": undefined
	"Rules.char.valid(document, '＃＄％＆。「」、', ['全記'])": undefined
	"Rules.char.valid(document, '＃＄％＆。「」、', ['全角和記号'])": undefined
	"Rules.char.valid(document, '＃＄％＆。「」、', ['全和記号'])": undefined
	"Rules.char.valid(document, '＃＄％＆。「」、', ['全和記'])": undefined
	"Rules.char.valid(document, '。「」、', ['j'])": undefined
	"Rules.char.valid(document, '。「」、', ['和記号'])": undefined
	"Rules.char.valid(document, '。「」、', ['和記'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['ｱ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['ｶ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['ｶﾅ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['ｶﾀｶﾅ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['半角カ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['半角カナ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['半角カタカナ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['半カ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['半カナ'])": undefined
	"Rules.char.valid(document, 'ｱｲｳｴｵ', ['半カタカナ'])": undefined
	"Rules.char.valid(document, 'abcABC0123ひらがなカタカナ', ['adあア'])": undefined
	"Rules.char.valid(document, 'abcABC0123ひらがなカタカナ#$%&', ['adあア@'])": undefined
	"Rules.char.valid(document, 'abcABC0123ひらがなカタカナ#$%&。「」、', ['adあア@j'])": undefined
	"Rules.char.valid(document, 'abcABC0123ひらがなカタカナ#$%&。「」、', ['半角英数和記かカ'])": undefined
	"Rules.date.valid(document, { gengo: '明治', year: 1, month: 1, date: 1 })": '明治 は 9 月 8 日からです'
	"Rules.date.valid(document, { gengo: '大正', year: 1, month: 1, date: 1 })": '大正 は 7 月 30 日からです'
	"Rules.date.valid(document, { gengo: '昭和', year: 1, month: 1, date: 1 })": '昭和 は 12 月 25 日からです'
	"Rules.date.valid(document, { gengo: '平成', year: 1, month: 1, date: 1 })": '平成 は 1 月 8 日からです'
	"Rules.date.valid(document, { gengo: '明治', year: 100, month: 1, date: 1 })": '明治 は 45 年 7 月 29 日までです'
	"Rules.date.valid(document, { gengo: '大正', year: 100, month: 1, date: 1 })": '大正 は 15 年 12 月 24 日までです'
	"Rules.date.valid(document, { gengo: '昭和', year: 100, month: 1, date: 1 })": '昭和 は 64 年 1 月 7 日までです'
	"Rules.date.valid(document, { gengo: '平成', year: 100, month: 1, date: 1 })": '未来の日付です'
	"Rules.date.valid(document, { year: 1970, month: 1, date: 1 })": undefined
	"Rules.date.valid(document, { year: 1999, month: 19, date: 66 })": '19 月はありません'
	"Rules.date.valid(document, { year: 1900, month: 2, date: 29 })": '1900 年 2 月に 29 日はありません'
	"Rules.date.valid(document, { year: 2000, month: 2, date: 29 })": undefined
	"Rules.date.valid(document, { year: 2001, month: 2, date: 29 })": '2001 年 2 月に 29 日はありません'
	"Rules.date.valid(document, { year: 2004, month: 2, date: 29 })": undefined
	"Rules.date.valid(document, { year: 2004, month: 6, date: 31 })": '2004 年 6 月に 31 日はありません'
	"Rules.date.valid(document, { year: 2016, month: 1, date: 1 })": '未来の日付です'
	"Rules.date.valid(document, { year: 1970, month: 1 })": undefined
	"Rules.date.valid(document, { year: 1999, month: 19 })": '19 月はありません'
	"Rules.date.valid(document, { year: 2001, month: 2 })": undefined
	"Rules.date.valid(document, { year: 2004, month: 2 })": undefined
	"Rules.date.valid(document, { year: 2004, month: 6 })": undefined
	"Rules.date.valid(document, { year: 2016, month: 1 })": '未来の日付です'
	"Rules.date.valid(document, { year: 1994, month: 1, date: 1 }, { age: [18] })": undefined
	"Rules.date.valid(document, { year: 1996, month: 1, date: 1 }, { age: [18] })": undefined
	"Rules.date.valid(document, { year: 1997, month: 1, date: 1 }, { age: [18] })": undefined
	"Rules.date.valid(document, { year: 1998, month: 1, date: 1 }, { age: [18] })": '18 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2000, month: 1, date: 1 }, { age: [18] })": '18 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2002, month: 1, date: 1 }, { age: [18] })": '18 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2004, month: 1, date: 1 }, { age: [18] })": '18 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2006, month: 1, date: 1 }, { age: [18] })": '18 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2008, month: 1, date: 1 }, { age: [18] })": '18 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2010, month: 1, date: 1 }, { age: [18] })": '18 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1994, month: 1, date: 1 }, { age: [null, 18] })": '18 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1996, month: 1, date: 1 }, { age: [null, 18] })": '18 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1997, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 1998, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 2000, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 2002, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 2004, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 2006, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 2008, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 2010, month: 1, date: 1 }, { age: [null, 18] })": undefined
	"Rules.date.valid(document, { year: 1936, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1937, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1938, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1939, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1940, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1941, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1942, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1943, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1944, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1945, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1946, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1947, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1948, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1949, month: 1, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1949, month: 2, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1949, month: 3, date: 1 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1949, month: 3, date: 2 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1949, month: 3, date: 3 }, { age: [20,65] })": '65 歳以下の方しかお申込みできません' # 2015/3/3実施時点
	"Rules.date.valid(document, { year: 1949, month: 3, date: 4 }, { age: [20,65] })": undefined # 2015/3/3実施時点
	"Rules.date.valid(document, { year: 1949, month: 3, date: 5 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1949, month: 4, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1949, month: 5, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 2, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 3, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 3, date: 2 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 3, date: 3 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 3, date: 4 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 3, date: 5 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1950, month: 4, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1951, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1952, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1986, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1987, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1988, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1989, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1991, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1990, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1992, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1993, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1994, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1995, month: 1, date: 1 }, { age: [20,65] })": undefined
	"Rules.date.valid(document, { year: 1996, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1997, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1998, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 1999, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2000, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2001, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2002, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2003, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2004, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2005, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2006, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2007, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2008, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2009, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2010, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2011, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2012, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2013, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2014, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2015, month: 1, date: 1 }, { age: [20,65] })": '20 歳以上の方しかお申込みできません'
	"Rules.date.valid(document, { year: 2016, month: 1, date: 1 }, { age: [20,65] })": '未来の日付です'
	"Rules.date.valid(document, { year: 2017, month: 1, date: 1 }, { age: [20,65] })": '未来の日付です'
	"Rules.date.valid(document, { year: 1992, month: 12 }, { age: [20] })": undefined
	"Rules.date.valid(document, { year: new Date().getFullYear(), month: new Date().getMonth() + 1, date: new Date().getDate() })": undefined
	"Rules.date.valid(document, { year: new Date().getFullYear(), month: new Date().getMonth() + 1, date: new Date().getDate() + 1 })": '未来の日付です'
	"Rules.date.valid(document, { year: new Date().getFullYear(), month: new Date().getMonth() + 1 })": undefined
	"Rules.date.valid(document, { gengo: '平成', year: new Date().getFullYear() - 1988, month: new Date().getMonth() + 1 })": undefined
	"Rules.codeNum.valid(document, 123, [10, false, false])": '桁数が足りません'
	"Rules.codeNum.valid(document, 123, [5, false, false])": '桁数が足りません'
	"Rules.codeNum.valid(document, 'AB123', [20, true, false])": '桁数が足りません'
	"Rules.codeNum.valid(document, 'AD-123-12310230', [25, true, true])": '桁数が足りません'
	"Rules.codeNum.valid(document, 'AD-123-12310230', [25, false, true])": '半角数字/ハイフンを入力してください'
	"Rules.codeNum.valid(document, 'AD-123-12310230', [25, true, false])": '半角英数を入力してください'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['半角']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['半']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['a']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['A']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['d']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['D']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['0']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、', ['@']).toString()": 'abcABC0123456#$%&。「」、'
	"Rules.char.cast(document, 'アイウエオ', ['あ']).toString()": 'あいうえお'
	"Rules.char.cast(document, 'アイウエオ', ['か']).toString()": 'あいうえお'
	"Rules.char.cast(document, 'アイウエオ', ['かな']).toString()": 'あいうえお'
	"Rules.char.cast(document, 'アイウエオ', ['ひらがな']).toString()": 'あいうえお'
	"Rules.char.cast(document, 'あいうえお', ['ア']).toString()": 'アイウエオ'
	"Rules.char.cast(document, 'あいうえお', ['カ']).toString()": 'アイウエオ'
	"Rules.char.cast(document, 'あいうえお', ['カナ']).toString()": 'アイウエオ'
	"Rules.char.cast(document, 'あいうえお', ['カタカナ']).toString()": 'アイウエオ'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['全角']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['全']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['ａ']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['Ａ']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['ｄ']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['Ｄ']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['０']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'abcABC0123456#$%&。「」、', ['＠']).toString()": 'ａｂｃＡＢＣ０１２３４５６＃＄％＆。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２ひらがなカタカナ', ['aア']).toString()": 'abcABC012ヒラガナカタカナ'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２ひらがなカタカナ#$%&', ['Ａあ']).toString()": 'ａｂｃＡＢＣ０１２ひらがなかたかな＃＄％＆'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２ひらがなカタカナ#$%&。「」、', ['aあア']).toString()": 'abcABC012ひらがなカタカナ#$%&。「」、'
	"Rules.char.cast(document, 'ａｂｃＡＢＣ０１２ひらがなカタカナ#$%&。「」、', ['半角ｶ']).toString()": 'abcABC012ﾋﾗｶﾞﾅｶﾀｶﾅ#$%&｡｢｣､'
	"new VString('!# $%').isOnly(VString.SIGN)": true
	"new VString('!# $%abcABC012').isOnly(VString.SIGN)": false
	"new VString('012789').isOnly(VString.DIGIT)": true
	"new VString('-1.345px').isOnly(VString.DIGIT)": false
	"new VString('012 789').isOnly(VString.DIGIT, true)": true
	"new VString('abcABC').isOnly(VString.ALPHABET)": true
	"new VString('John Smith').isOnly(VString.ALPHABET)": false
	"new VString('ひらがーな').isOnly(VString.HIRAGANA)": true
	"new VString('ひらが〜な').isOnly(VString.HIRAGANA)": false
	"new VString('ひら　がーな').isOnly(VString.HIRAGANA, true)": true
	"new VString('カタカーナ').isOnly(VString.KATAKANA)": true
	"new VString('カタカ〜ナ').isOnly(VString.KATAKANA)": false
	"new VString('カタ	カーナ').isOnly(VString.KATAKANA, true)": true
	"new VString('！＃＄％').isOnly(VString.FULLWIDTH_SIGN)": true
	"new VString('　').isOnly(VString.FULLWIDTH_SIGN)": false
	"new VString('０２３').isOnly(VString.FULLWIDTH_DIGIT)": true
	"new VString('9999').isOnly(VString.FULLWIDTH_DIGIT)": false
	"new VString('Ａｂｓ').isOnly(VString.FULLWIDTH_ALPHABET)": true
	"new VString('Åｂｓ').isOnly(VString.FULLWIDTH_ALPHABET)": false
	"new VString('「　」～〜').isOnly(VString.JAPANESE_SIGN)": true
	"new VString('！＂＃＄％＆').isOnly(VString.JAPANESE_SIGN)": false
	"new VString('ｱｲｳｴｵｶｷｸｹｺ').isOnly(VString.NARROW_KATAKANA)": true
	"new VString('ｦﾞ｡｢｣､･').isOnly(VString.NARROW_KATAKANA)": false
	"new VString('｡｢｣､･').isOnly(VString.NARROW_JAPANESE_SIGN)": true
	"new VString('!#$~').isOnly(VString.NARROW_JAPANESE_SIGN)": false
	"new VString('abcABC012').isOnly(VString.ALPHANUMERIC)": true
	"new VString('abcABC012!#$').isOnly(VString.ALPHANUMERIC)": false
	"new VString('ＡＢＣ０１２').isOnly(VString.FULLWIDTH_ALPHANUMERIC)": true
	"new VString('Ａ０あ').isOnly(VString.FULLWIDTH_ALPHANUMERIC)": false
	"new VString('あいうえおアイウエオ').isOnly(VString.KANA)": true
	"new VString('亜衣宇恵緒').isOnly(VString.KANA)": false
	"new VString('「もしもし」').isOnly(VString.KANA_WITH_SIGN)": true
	"new VString('「ＨＥＬＬＯ」').isOnly(VString.KANA_WITH_SIGN)": false
	"new VString('｢ﾊﾞｰﾛｰ｣').isOnly(VString.NARROW_JAPANESE)": true
	"new VString('｢foo｣').isOnly(VString.NARROW_JAPANESE)": false
	"new VString('john｢ｺﾝﾆﾁﾜ｣').isOnly(VString.ANK)": true
	"new VString('abcABC012ｱｲｳｴｵ!#$').isOnly(VString.ANK)": false
	"new VString('abcABC012').isOnly(VString.ALPHABET | VString.DIGIT)": true
	"new VString('abcABC012ひらがな').isOnly(VString.ALPHABET | VString.DIGIT | VString.HIRAGANA)": true
	"new VString(' 	　abcABC012ひらがな　　').trim().toString()": 'abcABC012ひらがな'
	"new VString('　！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン゛゜ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヷヸヴヹヺ。「」、・をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゛ゐ゛ゔゑ゛を゛わ゙ゐ゙ゔゑ゙を゙').toNarrow().toString()": ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン゛゜ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヷヸヴヹヺ。「」、・をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゛ゐ゛ゔゑ゛を゛わ゙ゐ゙ゔゑ゙を゙'
	"new VString('　！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン゛゜ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヷヸヴヹヺ。「」、・をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゛ゐ゛ゔゑ゛を゛わ゙ゐ゙ゔゑ゙を゙').toNarrow(true).toString()": ' !"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟﾜﾞｲﾞヴｴﾞｦﾞ｡｢｣､･をぁぃぅぇぉゃゅょっｰあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわﾞゐﾞゔゑﾞをﾞわﾞゐﾞゔゑﾞをﾞ'
	"new VString(' !\"#$%&\\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~').toWide().toString()": '　！＂＃＄％＆＇（）＊＋，－．／０１２３４５６７８９：；＜＝＞？＠ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ［］＾＿｀ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ｛｜｝～'
	"new VString('ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟﾜﾞｲﾞｳﾞｴﾞｦﾞ｡｢｣､･').toWide().toString()": 'ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワン゛゜ガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヷヸヴヹヺ。「」、・'
	"new VString('ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟﾜﾞｲﾞｳﾞｴﾞｦﾞヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヷヸヴヹヺ').toHiragana().toString()": 'をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゛ゐ゛ゔゑ゛を゛をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゛ゐ゛ゔゑ゛を゛'
	"new VString('ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝｶﾞｷﾞｸﾞｹﾞｺﾞｻﾞｼﾞｽﾞｾﾞｿﾞﾀﾞﾁﾞﾂﾞﾃﾞﾄﾞﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟﾜﾞｲﾞｳﾞｴﾞｦﾞヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヷヸヴヹヺ').toHiragana(true).toString()": 'をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゙ゐ゙ゔゑ゙を゙をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゙ゐ゙ゔゑ゙を゙'
	"new VString('をぁぃぅぇぉゃゅょっーあいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわんがぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽわ゛ゐ゛ゔゑ゛を゛').toKatakana().toString()": 'ヲァィゥェォャュョッーアイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワンガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポヷヸヴヹヺ'
