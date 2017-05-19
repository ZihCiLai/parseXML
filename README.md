# parseXML
* ####  Parse至標籤的開始時會呼叫此方法:<br />func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])

* ####  Parse至標籤的結束時會呼叫此方法:<br />func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?):current

* ####  Parse至標籤的內容時會呼叫此方法:<br />func parser(_ parser: XMLParser, foundCharacters string: String)


* iOS內建提供了NSXMLParser可供使用,有些人覺得它的效能不好、用起來麻煩, 所以目前網路上有眾多的3rd party的XML Parser可以選擇使用,但以實際使用的經驗,對於一般的使用來說其實還可以接受,且這是Apple所提供的標準元件,日後的維護沒有問題,若非您有特別的考量,不然選擇使用內建的NSXML Parser是個 不錯的選擇。   

####  維基百科: 
可延伸標記式語言（英語：Extensible Markup Language，簡稱：XML），是一種標記式語言。標記指電腦所能理解的資訊符號，通過此種標記，電腦之間可以處理包含各種資訊的文章等。如何定義這些標記，既可以選擇國際通用的標記式語言，比如HTML，也可以使用像XML這樣由相關人士自由決定的標記式語言，這就是語言的可延伸性。XML是從標準通用標記式語言（SGML）中簡化修改出來的。它主要用到的有可延伸標記式語言、可延伸樣式語言（XSL）、XBRL和XPath等。  
XML定義結構、儲存資訊、傳送資訊。下例為小張傳送給大元的便條，儲存為XML。
###### \<?xml version="1.0"?>
###### <信件>
###### <收件人>大元</收件人>
###### <發件人>小張</發件人>
###### <主題>問候</主題>
###### <具體內容>早啊，飯吃了沒？ </具體內容>
###### </信件>
