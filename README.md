# ���ڰ�Ȩ

> ��ֻ���Լ�Ūһ������ʱ����Ҫ�и�������ַ��дһ��docker���÷��㣬��ɾ��

# ֧�����ĵ�deepdive��˹̹����ѧ�Ŀ�Դ֪ʶ��ȡ���ߣ���Ԫ���ȡ��

> deepdive����˹̹����ѧInfoLabʵ���ҿ�����һ����Դ֪ʶ��ȡϵͳ����ͨ�����ලѧϰ���ӷǽṹ�����ı��г�ȡ�ṹ���Ĺ�ϵ���� ������Ŀ�޸�����Ȼ���Դ����model����ʹ��֧�����ģ����ṩ����tutorial����������������һЩ������ĵ��Ż���

[ԭ��ַ��http://www.openkg.cn/dataset/cn-deepdive](http://www.openkg.cn/dataset/cn-deepdive)

# ����

##Tutorial: ��ȡ��˾ʵ���Ĺ�Ȩ���׹�ϵ

###0. ����׼��
####0.1. deepdive��װ
����CNdeepdive������install.sh��ѡ��1��װdeepdive��

���û���������deepdive�Ŀ�ִ���ļ�һ�㰲װ��~/local/bin�ļ����¡�
��~/.bash_profile������������ݲ����棺

    export PATH="/root/local/bin:$PATH"
Ȼ��ִ��source ~/.bash_profile���û���������

####0.2. postgresql��װ
����

     bash <(curl -fsSL git.io/getdeepdive) postgres 
��װpostgresql��
 
####0.3.nlp������װ    
����nlp_setup.sh����������standford nlp������

####0.4. ��Ŀ��ܴ
�����Լ�����Ŀ�ļ���***transaction***���ڱ���postgresql��Ϊ��Ŀ�������ݿ⣬������Ŀ�ļ����½������ݿ������ļ�:

     echo "postgresql://$USER@$HOSTNAME:5432/db_name" >db.url
     
����transaction�·ֱ������������ļ���***input***���ű��ļ���***udf***���û������ļ�app.ddlog��ģ�������ļ�deepdive.conf�� �ɲ��ո�����transaction�ļ���������ʽ��

��PS��transaction�ļ��������Ѿ�������ϵ���Ŀ����������Ľű��������ļ�������ֱ�Ӹ��ƣ�


deepdive�����˺ܶ��Լ����﷨������Զ����ű����������ݿ�Ĺ���һ��Ϊdeepdive do db_nameָ��û�ͨ������app.ddlogָʾ��������


###1. ʵ�鲽��
####1.1 . �������ݵ���

������Ҫ��֪ʶ���л�ȡ��֪���н��׹�ϵ��ʵ��ԣ�����Ϊѵ�����ݡ�����Ŀ���õ����ݴӹ�̩�����ݿ⣨<http://www.gtarsc.com>���й�˾��ϵ-��Ȩ����ģ�������ء�

(1).  ͨ��ƥ���н��׵Ĺ�Ʊ����Ժʹ���-��˾�ԣ����˳����ڽ��׹�ϵ�Ĺ�˾�ԣ�����transaction_dbdata.csv�С���csv�ļ�����input/�ļ����¡�

(2). ��app.ddlog�ж�����Ӧ�����ݱ�
    
    @source
    transaction_dbdata(
        @key
        company1_name text,
        @key
        company2_name text
    ).
 
(3). ����������postgresql���ݱ�   

    $ deepdive compile && deepdive do transaction_dbdata

- ��ִ��app.ddlogǰ������иĶ�����Ҫ��ִ��deepdive compile���������Ч
- ���ڲ�������������ı��deepdive���Զ�ȥinput�ļ������ҵ�ͬ��csv�ļ�����postgresql�ｨ����
- ��������ʱ��deepdive���ڵ�ǰ������������һ��ִ�мƻ��ļ�����vi�﷨һ������˺�ʹ��:wq���沢ִ�С�


####1.2. ����ȡ���µ���

(1). ׼������ȡ�����£�ʾ��ʹ�����й�˾���棩������Ϊarticles.csv������input�ļ����¡�

(2). ��app.ddlog�н�����Ӧ��articles��

    articles(
         id			text,
         content	text
    ).


(3). ͬ��ִ�������У��������µ�postgresql�С�

    $ deepdive do articles
    

deepdive����ֱ�Ӳ�ѯ���ݿ����ݣ���query������deepdive sql "sql���"�������ݿ���������в�ѯidָ����鵼���Ƿ�ɹ���

    $ deepdive query '?- articles(id, _).'
    
    id     
    ------------
    1201835868
    1201835869
    1201835883
    1201835885
    1201835927
    1201845343
    1201835928
    1201835930
    1201835934
    1201841180
    :
    
####1��3. ��nlpģ������ı�����

deepdiveĬ�ϲ���standford nlp�����ı����������ı����ݣ�nlpģ�齫�Ծ���Ϊ��λ������ÿ��ķִʡ�lemma��pos��NER�;䷨�����Ľ����Ϊ����������ȡ��׼�������ǽ���Щ�������sentences���С�
(1). ��app.ddlog�ļ��ж���sentences�����ڴ��nlp�����

    sentences(
    	doc_id         text,
    	sentence_index int,
    	sentence_text  text,
    	tokens         text[],
    	lemmas         text[],
       pos_tags       text[],
    	ner_tags       text[],
    	doc_offsets    int[],
    	dep_types      text[],
    	dep_tokens     int[]
	).
 
(2). ����NLP����ĺ���nlp_markup

    function nlp_markup over (
        doc_id  text,
        content text
    ) returns rows like sentences
    implementation "udf/nlp_markup.sh" handles tsv lines.

- ����һ��ddlog��������������������µ�doc\_id��content�������sentences����ֶθ�ʽ
- ��������udf/nlp\_markup.sh����nlpģ�飬����������ɷ���
- nlp_markup.sh�Ľű����ݼ�transactionʾ�������е�udf/�ļ��У�������udf/bazzar/parser�µ�run.shʵ�֡�

-
**ע�⣺ �˴���Ҫ���±���nlp����ģ��**

����transaction/udf/��Ŀ¼�µ�bazzar�ļ��е����Լ���Ŀ��udf/�С����ģ����Ҫ���±��롣����bazzar/parserĿ¼�£�ִ�б�������:

    sbt/sbt stage
    
������ɺ����target�����ɿ�ִ���ļ���

-

(3). ʹ�������﷨����nlp_markup��������articles���ж�ȡ���룬��������sentences���С�

    sentences += nlp_markup(doc_id, content) :-
    articles(doc_id, content).

(4). ���벢ִ��deepdive compile��deepdive do sentences�����������sentences���ݱ�

ִ��������������ѯ���ɽ����

    deepdive query '
    doc_id, index, tokens, ner_tags | 5
    ?- sentences(doc_id, index, text, tokens, lemmas, pos_tags, ner_tags, _, _, _).
    '    
    
���Կ���idΪ1201734370���µ�ǰ���Ľ��������


***tips:*** *���Կ���sentences������plan�а���articles���ִ�С�plan��ǰ����ð�ŵ��б�ʾĬ���Ѿ�ִ�У���������������Ҫ���ɡ����articles�и��£���Ҫ����deepdive redo articles������deepdive mark todo articles����articles���Ϊδִ�У�����������sentences�Ĺ����оͻ�Ĭ�ϸ���articles�ˡ�*

 **ע�⣺ ��һ���ܵĻ�ǳ�����������Ҫ�����Сʱ����ҿ��Լ���articles��������������ʱ�䣬���demo��


####1.4. ʵ���ȡ����ѡʵ�������

��һ��������Ҫ��ȡ�ı��еĺ�ѡʵ�壨��˾���������ɺ�ѡʵ��ԡ�

(1). ������app.ddlog�ж���ʵ�����ݱ�

    company_mention(
    	mention_id     text,
    	mention_text   text,
    	doc_id         text,
    	sentence_index int,
    	begin_index    int,
    	end_index      int
    ).

ÿ��ʵ�嶼�Ǳ��е�һ�����ݣ�ͬʱ�洢��ʵ���ھ��е���ʼλ�úͽ���λ�á�

(2). �ٶ���ʵ���ȡ�ĺ�����

    function map_company_mention over (
        doc_id         text,
        sentence_index int,
        tokens         text[],
        ner_tags       text[]
    ) returns rows like company_mention
    implementation "udf/map_company_mention.py" handles tsv lines.
    

- map\_company\_mention.py������������ű�����ÿ�����ݿ��еľ��ӣ��ҳ�������NER���ΪORG�����У������������˴��������ű�ҲҪ���ƹ�ȥ������ű���һ�����ɺ�������yield��䷵������С�

(3). Ȼ����app.ddlog��д���ú�������sentences�������룬�����company_mention�С�

    company_mention += map_company_mention(
    doc_id, sentence_index, tokens, ner_tags
    ) :-
    sentences(doc_id, sentence_index, _, tokens, _, _, ner_tags, _, _, _).
    
(4). �����벢ִ�У�

    $ deepdive compile && deepdive do company_mention
    

(5). ��������ʵ��ԣ���ҪԤ���ϵ��������˾������һ�����ǽ�ʵ������ѿ�������ͬʱ���Զ���ű�����һЩ�������γɽ��������Ĺ�˾���������ݱ����£�

    transaction_candidate(
    	p1_id   text,
    	p1_name text,
    	p2_id   text,
    	p2_name text
    ).
    
(6). ͳ��ÿ�����ӵ�ʵ������
   
	num_company(doc_id, sentence_index, COUNT(p)) :-
    company_mention(p, _, doc_id, sentence_index, _, _).
    
(7). ������˺�����

    function map_transaction_candidate over (
        p1_id         text,
        p1_name       text,
        p2_id         text,
        p2_name      text
    ) returns rows like transaction_candidate
    implementation "udf/map_transaction_candidate.py" handles tsv lines.
    
(8). ���������ĵ��ã�

    transaction_candidate += map_transaction_candidate(p1, p1_name, p2, p2_name) :-
    num_company(same_doc, same_sentence, num_p),
    company_mention(p1, p1_name, same_doc, same_sentence, p1_begin, _),
    company_mention(p2, p2_name, same_doc, same_sentence, p2_begin, _),
    num_p < 5,
    p1_name != p2_name,
    p1_begin != p2_begin.
    
һЩ�򵥵Ĺ��˲�������ֱ��ͨ��app.ddlog�е����ݿ��﷨ִ�У�����p1\_name != p2\_name�����˵�������ͬʵ����ɵ�ʵ��ԡ�

��PS���˴������·�������뽫transform.py��company\_full\_short.csv�����·����Ϊ����·������

(9). ���벢ִ�У�

    $ deepdive compile && deepdive do transaction_candidate
    
���ɺ�ѡʵ���
    
####1.5. ������ȡ

��һ�����ǳ�ȡ��ѡʵ��Ե��ı�������

(1). ����������

    transaction_feature(
    	p1_id   text,
    	p2_id   text,
    	feature text
).

�����feature����ʵ��Լ�һϵ���ı������ļ��ϡ�

(2). ����feature����Ҫ������Ϊʵ��Ա���ı�����������������app.ddlog�ж������£�

     function extract_transaction_features over (
        p1_id          text,
        p2_id          text,
        p1_begin_index int,
        p1_end_index   int,
        p2_begin_index int,
        p2_end_index   int,
        doc_id         text,
        sent_index     int,
        tokens         text[],
        lemmas         text[],
        pos_tags       text[],
        ner_tags       text[],
        dep_types      text[],
        dep_tokens     int[]
    ) returns rows like transaction_feature
    implementation "udf/extract_transaction_features.py" handles tsv lines.

- ��������extract\_transaction\_features.py����ȡ���������������deepdive�Դ���ddlib�⣬�õ�����POS/NER/�����еĴ����������˴�Ҳ�����Զ���������

(3).��sentences���mention����join���õ��Ľ�����뺯���������transaction_feature���С�  
  
    transaction_feature += extract_transaction_features(
    p1_id, p2_id, p1_begin_index, p1_end_index, p2_begin_index, p2_end_index,
    doc_id, sent_index, tokens, lemmas, pos_tags, ner_tags, dep_types, dep_tokens
    ) :-
    company_mention(p1_id, _, doc_id, sent_index, p1_begin_index, p1_end_index),
    company_mention(p2_id, _, doc_id, sent_index, p2_begin_index, p2_end_index),
    sentences(doc_id, sent_index, _, tokens, lemmas, pos_tags, ner_tags, _, dep_types, dep_tokens).
    
(4). Ȼ����벢ִ�У������������ݿ⣺

     $ deepdive compile && deepdive do transaction_feature
     
ִ��������䣬�鿴���ɽ����
     
     deepdive query '| 20 ?- transaction_feature(_, _, feature).'
     
-----

feature                        
��������������������������������������������������������

 WORD\_SEQ\_[������ ���� ���� Ͷ�� ��չ ���� ���� ��˾]
 
 LEMMA\_SEQ\_[������ ���� ���� Ͷ�� ��չ ���� ���� ��˾]
 
  NER\_SEQ\_[ORG ORG ORG ORG ORG ORG ORG ORG]

 POS\_SEQ\_[NR NN NN NN NN NN JJ NN]

 W\_LEMMA\_L\_1\_R\_1\_[Ϊ]\_[�ṩ]

 W\_NER\_L\_1\_R\_1\_[O]\_[O]

 W\_LEMMA\_L\_1\_R\_2\_[Ϊ]\_[�ṩ ����]

 W\_NER\_L\_1\_R\_2\_[O]\_[O O]

 W\_LEMMA\_L\_1\_R\_3\_[Ϊ]\_[�ṩ ���� ����]

 W\_NER\_L\_1\_R\_3\_[O]\_[O O O]

 W\_LEMMA\_L\_2\_R\_1\_[��˾ Ϊ]\_[�ṩ]

 W\_NER\_L\_2\_R\_1\_[ORG O]\_[O]

 W\_LEMMA\_L\_2\_R\_2\_[��˾ Ϊ]\_[�ṩ ����]

 W\_NER\_L\_2\_R\_2\_[ORG O]\_[O O]

 W\_LEMMA\_L\_2\_R\_3\_[��˾ Ϊ]\_[�ṩ ���� ����]

 W\_NER\_L\_2\_R\_3\_[ORG O]\_[O O O]

 W\_LEMMA\_L\_3\_R\_1\_[���� ��˾ Ϊ]\_[�ṩ]

 W\_NER\_L\_3\_R\_1\_[ORG ORG O]\_[O]

 W\_LEMMA\_L\_3\_R\_2\_[���� ��˾ Ϊ]\_[�ṩ ����]

 W\_NER\_L\_3\_R\_2\_[ORG ORG O]\_[O O]
 
(20 rows)


:

���ڣ������Ѿ�������Ҫ�ж���ϵ��ʵ��Ժ����ǵ��������ϡ�

####1.6. �������
��һ��������ϣ���ں�ѡʵ����б��������������
- ������֪��ʵ��Ժͺ�ѡʵ��Թ���
- ���ù���򲿷�������ǩ

(1). ������app.ddlog�ﶨ��transaction_label���洢�ල���ݣ�

    @extraction
    transaction_label(
        @key
        @references(relation="has_transaction", column="p1_id", alias="has_transaction")
        p1_id   text,
        @key
        @references(relation="has_transaction", column="p2_id", alias="has_transaction")
        p2_id   text,
        @navigable
        label   int,
        @navigable
        rule_id text
    ).
    
rule_id�����ڱ�Ǿ�������ԵĹ������ơ�labelΪ��ֵ��ʾ����أ���ֵ��ʾ����ء�����ֵԽ�������Խ��

(2). ��ʼ�����壬����transaction_candidate��label������Ϊ�㡣

     transaction_label(p1, p2, 0, NULL) :- transaction_candidate(p1, _, p2, _).
     

(3).��ǰ��׼����db���ݵ���transaction\_label���У�rule_id���Ϊ"from\_dbdata"����Ϊ��̩�������ݱȽϹٷ������Ի��ڽϸߵ�Ȩ�أ�������Ϊ3����app.ddlog�ж������£�

    transaction_label(p1,p2, 3, "from_dbdata") :-
        transaction_candidate(p1, p1_name, p2, p2_name), transaction_dbdata(n1, n2),
        [ lower(n1) = lower(p1_name), lower(n2) = lower(p2_name) ;
          lower(n2) = lower(p1_name), lower(n1) = lower(p2_name) ].


(4). ���ֻ�������ص�ʵ��ԣ����ܺ�δ֪�ı�����ȡ��ʵ����غ϶Ƚ�С�����������������Ƶ�����˿���ͨ��һЩ�߼����򣬶�δ֪�ı�����Ԥ��ǡ�


     function supervise over (
        p1_id text, p1_begin int, p1_end int,
        p2_id text, p2_begin int, p2_end int,
        doc_id         text,
        sentence_index int,
        sentence_text  text,
        tokens         text[],
        lemmas         text[],
        pos_tags       text[],
        ner_tags       text[],
        dep_types      text[],
        dep_tokens     int[]
    ) returns (
        p1_id text, p2_id text, label int, rule_id text
    )
    implementation "udf/supervise_transaction.py" handles tsv lines.
    
-	�����ѡʵ��ԵĹ����ı��������꺯��
-	��������udf/supervise\_transaction.py���������ƺ���ռ��Ȩ�ض����ڽű��С���app.ddlog�ж����Ǻ�����


(5). ���ñ�Ǻ�����������鵽������д��transaction_label���С�  


    transaction_label += supervise(
    p1_id, p1_begin, p1_end,
    p2_id, p2_begin, p2_end,
    doc_id, sentence_index, sentence_text,
    tokens, lemmas, pos_tags, ner_tags, dep_types, dep_token_indexes
    ) :-
    transaction_candidate(p1_id, _, p2_id, _),
    company_mention(p1_id, p1_text, doc_id, sentence_index, p1_begin, p1_end),
    company_mention(p2_id, p2_text, _, _, p2_begin, p2_end),
    sentences(
        doc_id, sentence_index, sentence_text,
        tokens, lemmas, pos_tags, ner_tags, _, dep_types, dep_token_indexes
    ).
    
(6). ��ͬ�Ĺ�����ܸ�������ͬ��ʵ��ԣ���δ������ͬ�����෴��label������transaction_label_resolved��ͳһʵ��Լ��label������label��ͣ��ڶ��������֪ʶ���ǵĽ���У�Ϊÿ��ʵ����vote��

     transaction_label_resolved(p1_id, p2_id, SUM(vote)) :-transaction_label(p1_id, p2_id, vote, rule_id).

(7). ִ����������õ����ձ�ǩ��
    
    $ deepdive do transaction_label_resolved
    
###2. ģ�͹���
ͨ��1�Ĳ��裬�����Ѿ��õ�������ǰ����Ҫ׼�������ݡ�������Թ���ģ���ˡ�

####2.1 ��������

(1). �������մ洢�ı�񣬡�������ʾ�˱����û�ģʽ�µı���������Ҫ�Ƶ���ϵ�ı���������Ԥ����ǹ�˾���ǹ����ڽ��׹�ϵ��

    @extraction
    has_transaction?(
        p1_id text,
        p2_id text
    ).

(2). ���ݴ��Ľ����������֪�ı���

    has_transaction(p1_id, p2_id) = if l > 0 then TRUE
                      else if l < 0 then FALSE
                      else NULL end :- transaction_label_resolved(p1_id, p2_id, l).
    
��ʱ�������еĲ��ֱ���label��֪����Ϊ�����������                  
    
(3). ������ִ�о��߱�

    $ deepdive compile && deepdive do has_transaction
    

####2.2 ����ͼ����

    
(1). ָ������

��ÿһ��has_transaction�е�ʵ��Ժ�����������������ͨ������factor�����ӣ�ȫ��ѧϰ��Щ������Ȩ�ء���app.ddlog�ж��壺

    @weight(f)
    has_transaction(p1_id, p2_id) :-
        transaction_candidate(p1_id, _, p2_id, _),
        transaction_feature(p1_id, p2_id, f).

(2). ָ���������������

���ǿ���ָ�����ű���������صĹ��򣬲������������Ȩ�ء�����c1��c2�н��ף������Ƴ�c2��c1Ҳ�н��ס�����һ������ȷ���Ķ�����˸���ϸ�Ȩ�أ�

     @weight(3.0)
     has_transaction(p1_id, p2_id) => has_transaction(p2_id, p1_id) :-
        transaction_candidate(p1_id, _, p2_id, _).
        

��������������ʹ��deepdive�ܺõ�֧���˶��ϵ�µĳ�ȡ��

(3). ��󣬱��룬���������յĸ���ģ�ͣ�

    $ deepdive compile && deepdive do probabilities
    
�鿴����Ԥ��Ĺ�˾�佻�׹�ϵ���ʣ�

    $ deepdive sql "SELECT p1_id, p2_id, expectation FROM has_transaction_label_inference ORDER BY random() LIMIT 20"
    

------

 p1\_id         				|         p2\_id               		 | expectation 
-----------------------  |  -----------------------| -------------
 1201778739\_118\_170\_171 	| 1201778739\_118\_54\_60 	 |           0
 1201778739\_54\_30\_35    	| 1201778739\_54\_8\_11    	|       0.035
 1201759193\_1\_26\_31     	| 1201759193\_1\_43\_48  	 |        0.07
 1201766319\_65\_331\_331  | 1201766319\_65\_159\_163 |           0
 1201761624\_17\_30\_35    | 1201761624\_17\_9\_14    |       0.188
 1201743500\_3\_0\_5       | 1201743500\_3\_8\_14     |       0.347
 1201789764\_3\_16\_21     | 1201789764\_3\_75\_76    |           0
 1201778739\_120\_26\_27   | 1201778739\_120\_29\_30  |       0.003
 1201752964\_3\_21\_21     | 1201752964\_3\_5\_10     |       0.133
 1201775403\_1\_83\_88     | 1201775403\_1\_3\_6      |           0
 1201778793\_15\_5\_6      | 1201778793\_15\_17\_18   |       0.984
 1201773262\_2\_85\_88     | 1201773262\_2\_99\_99    |       0.043
 1201734457\_24\_19\_20    | 1201734457\_24\_28\_29   |       0.081
 1201752964\_22\_48\_50    | 1201752964\_22\_9\_10    |       0.013
 1201759216\_5\_38\_44     | 1201759216\_5\_55\_56    |       0.305
 1201755097\_4\_18\_22     | 1201755097\_4\_52\_57    |           1
 1201750746\_2\_0\_5       | 1201750746\_2\_20\_26    |       0.034
 1201759186\_4\_45\_46     | 1201759186\_4\_41\_43    |       0.005
 1201734457\_18\_7\_11     | 1201734457\_18\_13\_18   |       0.964
 1201759263\_36\_18\_20    | 1201759263\_36\_33\_36   |       0.002
        

���ˣ����ǵĽ��׹�ϵ��ȡ�ͻ�������ˡ�������ϸ˵�����<http://deepdive.stanford.edu>

        







    


     





    







