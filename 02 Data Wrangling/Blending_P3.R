
# Change the USER and PASS below to be your UTEid
premature_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from premature"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

infections_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

trauma_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from trauma"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


join_df <- full_join(trauma_df, premature_df, by = c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR) 
#head(join_df)
join_df_2 <- left_join(join_df,infections_df,by=c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR)
#View(join_df_2)
join_df_3 <- right_join(join_df, infections_df, by=c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR)

join_df_2 <- join_df_2 %>% filter(COUNTRY %in% c("India", "China"))
ggplot() +
  coord_cartesian()+
  scale_x_continuous()+
  scale_y_continuous()+
  facet_wrap(~COUNTRY)+
 # scale_fill_manual(labels="legend")+
  labs(title="Total Infant Deaths in India and China")+ 
  labs(x="YEAR", y="TOTAL DEATHS") +
  labs(color="Type of Death")+
 # scale_fill_discrete(name="Total Infant", labels=c("A", "B"))+
  layer (
    data = join_df_2,
    mapping = aes(x=YEAR, y=TRAUMA_TOTAL, color="Trauma"),
    stat = "identity", stat_params = list(),
    geom = "smooth", geom_params = list(), 
    position = position_identity()
  ) +

  layer (
    data = join_df_2,
    mapping = aes(x=YEAR, y=RESP_TOTAL, color="Respiratory"),
    stat = "identity", stat_params = list(),
    geom = "smooth", geom_params = list(),
    position = position_identity()
  ) +
  layer (
    data = join_df_2,
    mapping = (aes(x=YEAR, y=PREM_TOTAL, color="Premature")),
    stat = "identity", stat_params = list(),
    geom = "smooth", geom_params = list(),
    position = position_identity()
  )

