
premature_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from premature"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

infections_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

trauma_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from trauma"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))



join_df <- inner_join(trauma_df, premature_df, by = c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR) 

join_df_2 <- left_join(join_df,infections_df,by=c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR)


trauma <- join_df_2 %>% group_by(COUNTRY) %>% summarise(total = sum(TRAUMA_TOTAL) + sum(PREM_TOTAL) + sum((RESP_TOTAL)),pcnt_trauma = (sum(TRAUMA_TOTAL)/total)*100,pcnt_prematurity = (sum(PREM_TOTAL)/total)*100, pcnt_respinf = (sum(RESP_TOTAL)/total)*100,pcnt_0_to_27_days = ((sum(PREM_0_TO_27_DAYS)+sum(RESP_0_TO_27_DAYS)+sum(TRAUMA_0_TO_27_DAYS))/total)*100) %>% arrange(desc(pcnt_0_to_27_days))

vis_df <- trauma %>% filter(total>100000) %>% head(10) 

vis_df[(c('COUNTRY','pcnt_prematurity'))]

ggplot(data = vis_df, mapping= aes(x=pcnt_0_to_27_days,y=total,color=pcnt_prematurity)) + labs(title="2000-2013") + facet_wrap(~COUNTRY) + geom_jitter(position=position_jitter(width=4,height=1.5),size=5) 


