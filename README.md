# ルールパラメータ

**name属性**をキーにパラメータ設定したハッシュを`jQuery.fn.validation`の第一引数に渡す。

## グループ化
- group:`グループ名`

## 必須項目
- require
- require:`関数名`
- require:`関数名`(`パラメータ`)
- require:`関数名`(:`name`)

### require
text系では空もしくは空白文字列だけだった場合、checkbox/radio系では選択されていなかった場合にエラーとする。

### require:`関数名`
独自の必須チェック関数で評価する。

### require:`関数名`(`パラメータ`)
任意の値を渡して独自の必須チェック関数で評価する。カンマ区切りで複数渡せる。

### require:`関数名`(:`name`)
他の要素の値を渡して独自の必須チェック関数で評価する

### 例
```javascript
var rules = {
	rule1: "require",
	rule2: "require:foo",
	rule3: "require:foo(123)",
	rule4: "require:bar(あいうえお)",
	rule5: "require:bar(:rule1)",
	rule6: "require:baz(rule1,:rule2,0)", // 第一引数の"rule1"は:がないのでそのまま文字列として渡される。
	rule7: "require:hoge(1,2,3) group:hoge",
	rule8: "require:hoge(4,5,6) group:hoge"
};

$('form').validation(rules, {
	// 独自関数
	baz: {
		valid: function (value, args) {
			// rule6の場合
			args[0]; // => "rule1"
			args[1]; // => rule2の値
			args[2]; // => "0"
		}
	},
	hoge: {
		isGroupRule: true,
		valid: function (values, args) {
			// 最初に指定されたパラメータしか渡されない。
			// rule8のパラメータは無視される。
			args; // => ["1", "2", "3"]
		}
	}
});
```

## 独自関数
- `関数名`
- `関数名`(`パラメータ`)
- `関数名`(:`name`)
- `関数名`:`ラベル名`

### `関数名`
独自の関数で評価する。

### `関数名`(`パラメータ`)
任意の値を渡して独自関数で評価する。カンマ区切りで複数渡せる。

### `関数名`(:`name`)
指定したname属性の要素の値を渡して独自関数で評価する。カンマ区切りで複数渡せる。

### `関数名`:`ラベル名`
グループルールの関数に値を渡す際のキー文字列を指定する。

### 例

```javascript
var rules = {
	rule1: "foo",
	rule2: "foo(123)",
	rule3: "bar(あいうえお)",
	rule4: "bar(:rule1)",
	rule5: "baz(rule1,:rule2,0)", // 第一引数の"rule1"は:がないのでそのまま文字列として渡される。
	apple: "fruits:red group:fruitsGroup",
	banana: "fruits:yellow group:fruitsGroup"
};

$('form').validation(rules, {
	// 独自関数
	fruits: {
		isGroupRule: true,
		valid: function (values, args) {
			values.red; // => appleの値
			values.yellow; // => bananaの値
		}
	}
});
```

## 除外関数
- ignore(`文字列`)

### ignore(`文字列`)
指定した文字列は値がないものとして扱われる

### 例

```javascript
var rule = {
	gender: 'require ignore(選択)'
};
```

```html
<select name="gender">
	<option value="選択">選択</option><!-- ここを選択しているとエラーになる -->
	<option value="男性">男性</option>
	<option value="女性">女性</option>
</select>
```

## 他の要素のバリデーション
- call:`name or グループ名`

### 例
```javascript
var rules = {
	rule1: "require",
	rule2: "require"
	rule3: "require group:set",
	rule4: "require group:set",
	rule5: "call:rule1", // rule1のバリデーションも行う
	rule6: "call:set", // グループsetのバリデーション
	rule7: "call:rule1 call:rule2" // 複数呼び出し可
};
```

## ビルトイン関数
基本的に引数は省略可

- length(`文字列長`)
- hiragana(`スペース含むか`)
- katakana(`スペース含むか`)
- alpha
- uint
- char(`クエリ`)
- zenkaku
- notZero
- range(`最小値`,`最大値`,`間隔`,`単位`)
- mail
- mail:local, mail:domain
- date:gengo, date:year(`年齢制限`<sup>†</sup>), date:month, date:date, date:age(`制限年齢`), date:elapsedYear, date:elapsedMonth<br><small>† ageが定義されている場合、ageが優先される。</small>
- codeNum(`桁数`,`アルファベット含むか`,`ハイフン含むか`)

