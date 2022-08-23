現状: 博士前期課程生
好きな物: 酒 麻雀 馬

この日記は自作の形式で書かれたテキストファイルを Common Lisp で書かれた自作のジェネレータを使つて HTML ファイルにし，それをネットリファイといふホスティングサーヴィスを使つてホスティングしてゐます．

この日記はワールド・ワイド・ウエブ上で見かける “危険なかをりがする” 人物をできるだけ模倣しようとしてゐます．

もし同じ形式の日記を書きたいと思ふのなら，まず GNU Common Lisp をインストールします．次に以下のファイルたちを wget などで取得するとよいでせう．

https://＜このブログのドメイン＞/generator/{main, reviser, header-generator}.lisp
https://＜このブログのドメイン＞/makefile

次のやうにディレクトリ・ファイルを設置してください． content ディレクトリは新規作成します．

├── content
│   └── 20220801
├── generator
│   ├── header-generator.lisp
│   ├── main.lisp
│   └── reviser.lisp
└── Makefile

content ディレクトリ内にエントリを書きます．どういふ形式で書けば良いかは https://＜このブログのドメイン＞/content/YYYYMMDD を見るとわかるでせう．ファイル名は YYYYMMDD 形式で保存してください．まだ複数の月には対応してゐませんが，そのうち対応するはずです．

エントリが書けたら make すれば index.html が生成されるはずです．
