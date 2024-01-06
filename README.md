# US-AltIME.ahk

2024/01/06 @kskmori


日本語(JIS)配列キーボードから英語(US)配列への変換と、左右Altキー・変換/無変換キーを使って日本語IMEをOn/Offするための AutoHotKey スクリプトです。

 * githubリポジトリ
   * https://github.com/kskmori/US-AltIME.ahk

## 概要

US-AltIME.ahk は以下の使い方ができます。

 * JIS配列からUS配列へ変換する。
 * 左右Altキーの空打ちで IME の On/Off を制御できる([alt-ime-ahk](https://github.com/karakaram/alt-ime-ahk/) と同じ機能)
 * 変換/無変換キーを、左右Altキーと同様に IME の On/Off制御や Alt+Tab に使用できる。
 * Escapeキーと `` `~ `` キーの配置を変更できる。
 * リモートデスクトップ環境でも干渉せずに利用できる。

なお、US-AltIME.ahk では CapsLockキーからControlキーへの変換はできません。CapsLockキーをControlキーとして利用したい場合には以下に示すような他のツールと組み合わせて利用してください。

 * CapsLock/Control変換ツールの例
   * [Ctrl2Cap v2.0](https://learn.microsoft.com/ja-jp/sysinternals/downloads/ctrl2cap) (Microsoft)
   * レジストリ変更による Scancode Map 設定

なお、これらの CapsLock/Control 変換ツールは管理者権限が必要になります。

どうしても管理者権限がない環境でCapsLock/Control 変換を利用したい場合は、[代替手段として英語(US101)用キーボードドライバ置換を利用する](#us101mode)(US101モード)という使い方も可能です。


## 使い方

### インストール

リリースパッケージ US-AltIME-*.zip を以下のページからダウンロードします。
 * https://github.com/kskmori/US-AltIME.ahk/releases/latest

展開してできる US-AltIME.exe を任意の場所に保存します。

実行は US-AltIME.exe をダブルクリックして起動するだけで利用可能です。必要に応じてスタートアップに登録して利用してください。

アンインストールは US-AltIME.exe を削除します。レジストリや設定ファイル等は残りません。

### メニュー・起動オプション

起動するとデフォルト設定で以下の変換が有効になります。

 * JIS配列からUS配列への変換(JIS2US変換)
 * 左右Altキーおよび変換/無変換キーによる IME On/Off 制御

通常はこのままで利用できますが、以下の動作を変更することができます。タスクトレイのアイコンを右クリックすると表示されるメニューもしくは起動オプションで変更します。

| メニュー      |  起動オプション | 説明 |
| :----------- | ---- | :------------------- |
|Suspend JIS2US | /N   | JIS2US変換を一時停止する。 IME制御のみ動作する。|
|Suspend on Remote | /R | リモートデスクトップ上で JIS2US変換を行わない。 |
|Escape Key    |      | Escapeキーと `` `~ `` キーの配置を変更する。<br>サブメニューで以下の3種類から選択可能。デフォルトは /E1 |
|              | /E1  | キートップ通りの配置。 外付けUS配列キーボード(HHKB等)向け |
|              | /E2  | Escapeキーと `` `~ `` キーの交換。 |
|              | /E3  | `` `~ `` キーを `]}`のキーに配置。JIS配列キーボード向け |
|(なし)         | /U  | US101モードで起動する。英語(US101)用キーボードドライバを使ってUS配列変換を行う場合に使用する。<br>起動オプションでのみ指定可能。メニューでは選択不可。|
|(なし)         | /C  | CapsLockキーをControl化する。US101モードでのみ有効。 <br>起動プションでのみ指定可能。メニューでは選択不可。|
|Suspend Hotkeys | -  | IME制御を含むすべての変換を一時的に停止する。 |
|Exit          | -    | 終了する。 |

/E1,/E2,/E3 は利用しているキーボードの配置と好みに合わせて選択してください。(/E3は単なる作者の個人的な好みです)

/N, /R オプションの使い方は[リモートデスクトップでの利用](#remote)を参照してください。

/U, /C オプションの使い方は[英語(US101)用キーボードドライバ置換の利用](#us101mode)を参照してください。

### 起動オプション指定方法

起動オプションを指定することで、動作を変更した状態で起動することができます。
以下の手順で US-AltIME.exe へのショートカットを作成し、ショートカットから起動してください。

 * US-AltIME.exe を右クリックし、「ショートカットの作成」を実行する。
 * 作成された「US-AltIME.exe - ショートカット」を右クリックし、「プロパティ」を開く。
 * 「ショートカット」タブを開き、「リンク先」の最後に起動オプションを空白文字区切りで追加する。
 * 「OK」で閉じる。

## <a id="remote">リモートデスクトップでの利用</a>

リモートデスクトップ環境で利用する場合、リモートデスクトップの接続元PC(ローカル側)と接続先PC(リモート側)の両方にインストールして使用します。

デフォルト設定のままではJIS2US変換が二重に動作してしまうため、以下(a)(b)のいずれかの設定で利用してください。


|設定| ローカル側設定 | リモート側設定 |説明 |
| ----- |  ----------- | ------------ | :------------------- |
| (a) | (デフォルト)   | Suspend JIS2US <br>(/N) |リモート側でのJIS2US変換を停止し、ローカル側での変換結果をリモート側でも利用する。  |
| (b) | Suspend on Remote <br>(/R) | (デフォルト)   |ローカル側での変換結果をリモート側では利用せず、ローカル側・リモート側でそれぞれ別個にJIS2US変換を実行する。  |

※ /N, /R 以外の設定は任意に併用可能です。

通常は設定(a)の使い方で問題ありませんが、以下のような問題が発生する場合や自分の好みに応じて設定(b)を利用してください。

 * リモートデスクトップをフルスクリーンで利用すると一部の文字が正常に変換されない。(例: ``'``が``7``になる、など)
 * リモートデスクトップをフルスクリーンで利用中、ウィンドウフォーカスを一旦ローカルに切り替えるとJIS2US変換が効かなくなってしまう。
   * (この問題については回避処理を入れてあるため解消されているはずですが、万が一発生した場合は一旦通常ウィンドウに戻して入力した後再度フルスクリーンに戻すことでも復旧できます)
 * リモート側PCに直接ログインして利用する使い方が多いため、設定の切り替えが頻繁に必要になってしまう。

設定(b)で利用する場合は、Escape Key の設定(/E1,/E2,/E3)をローカル側、リモート側両方で同じ設定をする必要があります。

なお、IME制御については常にローカル側・リモート側で個別に実行されます(設定(b)と同等の動作)。

----
## <a id="us101mode">代替手段: 管理者権限なしにCapsLockキーをControl化する</a>

### 英語(US101)用キーボードドライバ置換の利用

管理者権限がない環境でどうしても CapsLock キーを Controlキーに変換したい場合、英語(US101)用キーボードドライバ置換を利用するという手段があります。この場合 US-AltIME.ahk の US101モードと組み合わせて使用します。

英語用キーボードドライバ置換は一般ユーザ権限によるレジストリ変更のみで利用可能ですが、以下の注意点があります。十分注意の上、自己責任での利用をお願いいたします。

### 英語用キーボードドライバ置換の注意点
 * レジストリ変更を行うため、設定を誤ると入力ができなくなるなど動作不具合が発生する可能性があります。
 * 英語用キーボードドライバ置換では JIS2US変換を一時的に停止することはできません。元に戻すにはレジストリの削除とWindows再起動が必要になります。
 * Windows の入力言語が複数選択可能となるため、意図せず切り替わってしまうと日本語入力ができなくなる場合があります。
   * 突然日本語入力ができなくなった場合、タスクバーの言語アイコンが「Microsoft IME」(J文字に丸のアイコン)になっていることを確認してください。「日本」や「ENG」となっている場合はアイコンをクリックするなどで「Microsoft IME」に変更してください。
 * リモートデスクトップを利用する場合、リモート接続先で正常にUS配列とならない場合は一度サインアウト・サインインし直す必要があります。


### 設定手順

英語用キーボードドライバ置換を利用してCapsLockキーをControl化する設定手順は以下の通りです。

 * (1) Windows の「設定」→ 「言語とキーボードの設定」→「言語の追加」で「英語(米国)」を追加する。
 * (2) コマンドプロンプト等から ``regedit.exe`` を実行してレジストリエディタを起動する。
 * (3) レジストリエディタで ``HKEY_CURRENT_USER\Keyboard Layout\Preload`` に ``00000411``と``00000409``の両方が存在することを確認する。
 * (4) レジストリエディタで ``HKEY_CURRENT_USER\Keyboard Layout\Substitutes`` 以下で、右クリック→新規→文字列値を選択して以下のキーを作成する。
   * 名前: ``00000411``
   * データ: ``00000409``
   * 種類: ``REG_SZ``
 * (5) Windows を再起動する。
 * (6) キーボードからの入力がUS配列になっていることを確認する。
 * (7) US-AltIME.ahk に起動オプション " /U /C" を追加して、US101モードで起動する。


### US101モード用の起動オプションについての補足

US-AltIME.ahk を US101モード用の起動オプションで起動した場合以下の動作となります。

 * /U オプション
   * US101モードではメニューの表示が "Suspend US101" に変わります。
   * ただしこのメニューを選択してもJIS2US変換を一時停止することはできません。Escape Key と一部の追加キー(``\``)の変換のみが停止されます。
 * /C オプション
   * CapsLockキーを Controlキーに変更します。「交換」はできません。
   * /C を指定せずに起動した場合、CapsLock キーは単に無効化されます。

----
## 参考情報

 * [WindowsのAlt空打ちで日本語入力(IME)を切り替えるツールを作った](https://www.karakaram.com/alt-ime-on-off/)
   * https://www.karakaram.com/alt-ime-on-off/
   * https://github.com/karakaram/alt-ime-ahk
 * IME制御(AutoHotKey v2対応版)
   * https://github.com/kdr-s/ime.ahk-v2
 * AutoHotKey v2.0 公式ドキュメント
   * https://www.autohotkey.com/docs/v2/

以上