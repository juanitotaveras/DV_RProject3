require("jsonlite")
require("RCurl")
require("dplyr")
require("tidyr")
require("ggplot2")
require("extrafont")

# Change the USER and PASS below to be your UTEid
premature_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from premature"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

infections_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

trauma_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from trauma"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

names(fdf);names(sdf);names(tdf)
join_df <- inner_join(trauma_df, premature_df, by = c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR) 
head(join_df)
join_df_2 <- left_join(join_df,infections_df,by=c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR)
View(join_df_2)
join_df_3 <- right_join(join_df, infections_df, by=c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR)
View(join_df_3)

colnames(ddf) <- toupper(names(ddf)); dsdf <- inner_join(ddf, sdf, by = "DIAMOND_ID"); inner_join(dsdf, rdf, by = "RETAILER_ID") %>% tbl_df

colnames(ddf) <- toupper(names(ddf)); inner_join(ddf, sdf, by = "DIAMOND_ID") %>% inner_join(., rdf, by = "RETAILER_ID") %>% ggplot(aes(x=CARAT, y = NAME, color = CUT)) + geom_point()

joindf <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from DIAMONDS d join diam_sale s on (d.\\\"diamond_id\\\" = s.diamond_id) join diam_retailer r on (s.retailer_id = r.retailer_id)"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDB1.usuniversi01134.oraclecloud.internal',USER='DV_Diamonds',PASS='orcl',MODE='native_mode',MODEL='model',returnDimensions = 'False',returnFor = 'JSON'),verbose = TRUE))); joindf %>% ggplot(aes(x=carat, y = NAME, color = cut)) + geom_point()



