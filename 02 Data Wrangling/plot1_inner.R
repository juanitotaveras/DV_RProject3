require("jsonlite")
require("RCurl")
require("dplyr")
require("tidyr")
require("ggplot2")
require("extrafont")

# Change the USER and PASS below to be your UTEid
premature_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from premature"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))

infections_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))

trauma_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from trauma"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))

names(premature_df);names(infections_df);names(trauma_df)
join_df <- inner_join(trauma_df, premature_df, by = c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR) 
View(join_df)
summary(join_df)

join_df %>% mutate(Percent_trauma = TRAUMA_0_TO_27_DAYS / TRAUMA_TOTAL, Percent_prem = PREM_0_TO_27_DAYS / PREM_TOTAL) %>% filter(Percent_trauma>=.5 && Percent_prem>=.5) %>% ggplot(aes(x=Percent_prem, y=Percent_trauma, color=YEAR)) + geom_point() + labs(x="PERCENTAGE OF PREMATURITY-CAUSED DEATHS", y="PERCENTAGE OF TRAUMA-CAUSED DEATHS") + labs(title="DEATHS IN BABIES 0 TO 27 DAYS OLD")

join_df %>% mutate(Percent_trauma = TRAUMA_0_TO_27_DAYS / TRAUMA_TOTAL, Percent_prem = PREM_0_TO_27_DAYS / PREM_TOTAL) %>% filter(YEAR==2013) %>% ggplot(aes(x=Percent_prem, y=Percent_trauma, color=COUNTRY)) + geom_point() + labs(x="PERCENTAGE OF PREMATURITY-CAUSED DEATHS", y="PERCENTAGE OF TRAUMA-CAUSED DEATHS") + labs(title="DEATHS IN BABIES 0 TO 27 DAYS OLD IN 2013")

join_df %>% mutate(Percent_deaths_less_than_one_month = cume_dist(DEATHS_LESS_THAN_1_MONTH)) %>% filter( Percent_deaths_less_than_one_month <=.10 | Percent_deaths_less_than_one_month >= .90) %>% ggplot(aes(x=Percent_deaths_less_than_one_month, y=DEATHS_1_TO_59_MONTHS, color=COUNTRY)) + geom_point() + labs(x="CUMULATIVE DISTRIBUTION OF DEATHS", y="TOTAL DEATHS IN 1 TO 59 MONTHS") + labs(title="DEATHS IN BABIES LESS THAN ONE MONTH OLD")