## **Components of a DW**



35


36


37


38


39


40


**filled by at least one condition e.g. Timestamp, the extraction process begins a few moments later based on:**

          - **How many records on the base table.**

          - **Whether the columns used for the:**

✓ **WHERE**


✓ **SELECT are indexed or not.**

          - **The type of index used (in case of indexing)** ➔ **Primary index, Secondary/non-clustered index and/or Coverage Index**

          - **The capabilities of the used machine for the extraction process.**

- **ONE way to determine if the whole table download every time is a good choice or not is to roughly estimate the time**
**needed for the extraction process.**

     - **If the** **WHOLE TABLE EVERY TIME EXTRACTION is not possible and does not cope with the time associated to the**
**process (time constraints/standards) and/or business requirements, then we extract the data** **INCREMENTALLY (IF**
**POSSIBLE, ALSO).**

     - **Otherwise, the WHOLE TABLE EVERY TIME is used.**

- **Here the slowly changing dimensions and rapidly changing dimensions are determined and the way is determined.**


41


42


43


44


47


- **Data quality problems appear over:**

      - **Single data source problems:**

✓ **Schema Problems (E.g. lack of integrity constraints, poor schema design,…)**

✓ **Instance Problems ( E.g. data entry errors)**

      - **Multiple data source problems (problems on integration process):**

✓ **Schema Problems (E.g. heterogeneous data models and schema design,…)**

✓ **Instance Problems ( E.g. different representations, different measurement system …)**

- **So data sources may conflict with each other over three levels:**

      - Schema Level Inconsistencies,

      - Representation Level Inconsistencies, and

      - Data Level Inconsistencies


 **Data quality problems after the integration process**


 **If we integrated complete and accurate data sources 2 main**


**expected and/or existing)**


|Col1|DW Components<br>Transformation (T)<br>• Three well defined strategies to handle conflicts:<br>➢ Conflict Ignorance (CI) Strategy: ignore handling with conflicts<br>➢ Conflict Avoidance (CA) Strategy : Detect duplicates and avoid dealing with conflicts by taking a<br>pre-decision to handle conflicts, this decision may be<br>• Metadata based decision, or<br>• Content-based decision.<br>➢ Conflict Resolution (CR) Strategy : Detect duplicates and try to resolve them<br>• Metadata based decision, or<br>• Content-based decision|Col3|Col4|Col5|
|---|---|---|---|---|
|<br>|**Conflict Handling**<br>**Strategy/Step**|**Conflict Detection**|**Conflict Resolution**||
||~~**Conflict Ignorance**~~|~~X~~|~~X~~||
||~~**Conflict Ignorance**~~||||
||~~Conflict Avoidance~~||~~X~~||
||~~Conflict Avoidance~~|~~**√ **~~|~~**√ **~~|~~**√ **~~|
|Conflict Resolution|Conflict Resolution|**√ **|**√ **|**√ **|
|Conflict Resolution|Conflict Resolution||||


|Col1|DW Components<br>Transformation (T)<br>•<br>Employees integrated from different data sources<br>•<br>Extraction query gets ID, Name, Address, Zip_Code<br>of employees from different data sources and<br>applied the MAPPING required.<br>•<br>And the data retrieved during the user query is:|Col3|Col4|Col5|Col6|Col7|Col8|Col9|Col10|
|---|---|---|---|---|---|---|---|---|---|
||**ID**|**Name**|**Address**|**Zip_Code**||**Source**|**Confidence**|**Timestamp**||
||1234567|Dandarawy|Xyz|1234||S1|0.9|0.8||
||1234567|Dandarawy|Yxz|2341||S2|0.6|0.9||
||112|Dandarawy|Xyz|1234||S3|0.9|0.9||
|||||||||||
|||||||||||


|Col1|DW Components<br>Transformation (T)|Col3|Col4|Col5|Col6|Col7|Col8|Col9|Col10|Col11|
|---|---|---|---|---|---|---|---|---|---|---|
|**I**|**D**|**Name**|**Address**|**Address**|**Zip_Code**|**Source**|**Confidence**|**Confidence**|**Timestamp**||
|1|234567|Dandarawy|Xyz|Xyz|1234|S1|0.9|0.9|0.8||
|1|234567|Dandarawy|Yxz|Yxz|2341|S2|0.6|0.6|0.9||
||||||||||||
|1|12|Dandarawy|Xyz|Xyz|1234|S3|0.9|0.9|0.9||
||**ID**|**Name**|**Name**|**Address**|**Zip_Code**|**Source**|**Confidence**|**Timestamp**|**Timestamp**||
||1234567|Dandarawy|Dandarawy|Xyz|1234|S1|0.9|0.8|0.8||
||1234567<br>|Dandarawy<br>|Dandarawy<br>|Yxz<br>|2341<br>|S2<br>|0.6<br>|0.9<br>|0.9<br>||
||**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**|**Data fusion is the process of  combining these conflicting records into**<br>**COMPLETE**<br>**& **<br>**ACCURATE**<br>**Record.Instance based**<br>**and**<br>**MetaData Based Resolution/Fusion.**||


|ID<br>1<br>2|Col2|What is the data to be used whe<br>Extraction Query Q(Name,<br>load the data to DW ???<br>Address, Postal_Code, DoB)<br>T1, T2, or Both<br>Islamic_Customers|Col4|Col5|Col6|Col7|Col8|Col9|Col10|Col11|Col12|Col13|Col14|What is the data to be used whe<br>load the data to DW ???<br>T1, T2, or Both|Col16|Col17|Col18|Col19|Col20|Col21|Col22|Col23|Col24|Col25|Col26|n|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|**ID**<br>1<br>2|**ID**||**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|~~**Gender**~~|~~**Gender**~~|~~**Gender**~~|~~**Address**~~|~~**Address**~~|~~**Address**~~|~~**Address**~~|~~**Address**~~|~~**Postal_Code**~~|~~**Postal_Code**~~|~~**Postal_Code**~~|~~**DoB**~~|~~**DoB**~~|~~**DoB**~~|~~**DoB**~~|~~**DoB**~~||
|**ID**<br>1<br>2|**ID**||**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~|**N**~~**ame**~~||||||||||||||||||
|**ID**<br>1<br>2|1||Ali Zidane|Ali Zidane|Ali Zidane|Ali Zidane|Ali Zidane|Ali Zidane|Ali Zidane|1|1|1|XYFayoum|XYFayoum|XYFayoum|XYFayoum|XYFayoum|123456|123456|123456|11/8/1985|11/8/1985|11/8/1985|11/8/1985|11/8/1985||
|**ID**<br>1<br>2|2||Aly Zedan|Aly Zedan|Aly Zedan|Aly Zedan|Aly Zedan|Aly Zedan|Aly Zedan|1|1|1|MNCairo|MNCairo|MNCairo|MNCairo|MNCairo|123458|123458|123458|NULL|NULL|NULL|NULL|NULL||
|**ID**<br>1<br>2|2|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|Islamic Customers|Islamic Customers|Islamic Customers|Islamic Customers|Islamic Customers||||||
|**ID**<br>1<br>2||**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|**Customer**|
|**ID**|**ID**|**FN**<br>**N**|**FN**<br>**N**|**LN**<br>**ame**|**LN**<br>**ame**|**LN**<br>**ame**|**Gender**|**Gender**|**Gender**|**Gender**|**Address**|**Address**|**Address**|**Address**|**Postal_Code**|**Postal_Code**|**Postal_Code**|**Postal_Code**|**DoB**|**DoB**|**DoB**|**DoB**|**DoB**|**Type**|**Type**||
|**ID**|**ID**|**FN**<br>**N**|**FN**<br>**N**|**LN**<br>**ame**|**LN**<br>**ame**|**LN**<br>**ame**|||||||||||||||||||||
|1|1|Ali<br>Ali|Ali<br>Ali|Zidane<br> Zidane|Zidane<br> Zidane|Zidane<br> Zidane|M<br>1|M<br>1|M<br>1|M<br>1|XYFayoum|XYFayoum|XYFayoum|XYFayoum|123456|123456|123456|123456|11/8/1985|11/8/1985|11/8/1985|11/8/1985||Islamic<br>1|Islamic<br>1||
|2|2|Ali<br>Ali|Ali<br>Ali|Zidane<br> Zidane|Zidane<br> Zidane|Zidane<br> Zidane||M<br>1|M<br>1||MNCairo|MNCairo|MNCairo|MNCairo|123458|123458|123458|123458|11/8/19985|11/8/19985|11/8/19985|11/8/19985||Tradtiona<br>0|Tradtiona<br>0|l|
|2|2||||||||||||||||||||||||||
|||**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**||||||||||||||||||||
||**C**|**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**||||||||||||||||||||||
||**C**|**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**|**Client**<br>**ustomer**||||||||||||||||||||||
|**CID**|**CID**||||**Name**|**Name**|**Name**|**Name**|**Gender**|**Gender**|**Gender**|**Street**<br>|**Street**<br>|**Street**<br>|**Street**<br>|**City**<br>**Addres**|**City**<br>**Addres**|**State**<br>**s**|**State**<br>**s**|**Postal_Code**|**Postal_Code**|**Postal_Code**|**Postal_Code**|**Postal_Code**|**Ty**|**pe**|
|2|2||||Aly Zedan|Aly Zedan|Aly Zedan|Aly Zedan|1|1|1|M<br>|M<br>|M<br>|M<br>|N<br>MNCai|N<br>MNCai|Cairo<br>ro|Cairo<br>ro|123458|123458|123458|123458|123458||1|
|34|34|34|34|34|Noha Zidane|Noha Zidane|Noha Zidane|Noha Zidane|0|0|0|M<br>M|M<br>M|M<br>M|M<br>M|M<br>MFayo|M<br>MFayo|Fayoum<br>um|Fayoum<br>um|345789|345789|345789|345789|345789|0|0|


|Col1|Col2|Col3|• Different Representations.<br>• Different Identifiers/MatcherSet<br>• Different Mappings.<br>• Duplicated entities, and due to<br>duplicates inconsistencies<br>produced.<br>• Different lifetime states for the<br>same duplicated real-world entity<br>with inconsistent timestamps or<br>even absent.<br>X, Y, Z) Oo(X, M, N, T) Obj(Y, Z, N, T, F)|Col5|
|---|---|---|---|---|
||||||
||||||
||||||
||||||
|**O(**|**O(**|**O(**|**X, Y, Z)**|**X, Y, Z)**|
||||||


### **I ndependent** **Data Marts**

**The Independent Data**
**Mart is a data mart that**
**is built directly from the**

**legacy applications.**


Zidane 56


58


**Building**






63


Zidane
64


Zidane 67


- It unites the speed and end-user focus of a top-down approach with the


Zidane 72


