
# Change the USER and PASS below to be your UTEid
premature_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from premature"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

infections_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from infected"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

trauma_df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from trauma"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_kdk745', PASS='orcl_kdk745', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

names(fdf);names(sdf);names(tdf)
join_df <- full_join(trauma_df, premature_df, by = c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR) 
head(join_df)
join_df_2 <- left_join(join_df,infections_df,by=c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR)
View(join_df_2)
join_df_3 <- right_join(join_df, infections_df, by=c("COUNTRY","YEAR")) %>% arrange(COUNTRY, YEAR)
View(join_df_3)

#colnames(ddf) <- toupper(names(ddf)); dsdf <- inner_join(ddf, sdf, by = "DIAMOND_ID"); inner_join(dsdf, rdf, by = "RETAILER_ID") %>% tbl_df

#colnames(ddf) <- toupper(names(ddf)); inner_join(ddf, sdf, by = "DIAMOND_ID") %>% inner_join(., rdf, by = "RETAILER_ID") %>% ggplot(aes(x=CARAT, y = NAME, color = CUT)) + geom_point()

head(join_df_2)

join_df_2 <- join_df_2 %>% filter(COUNTRY=="India")
ggplot() +
  coord_cartesian()+
  scale_x_continuous()+
  scale_y_continuous()+
  geom_smooth(method="lm")+
  layer (
    data = join_df_2,
    mapping = aes(x=YEAR, y=TRAUMA_TOTAL, color=COUNTRY),
    stat = "identity", stat_params = list(),
    geom = "point", geom_params = list(),
    position = position_jitter(width = 0.3, height=0)
  ) +
  layer (
    data = join_df_2,
    mapping = (aes(x=YEAR, y=TRAUMA_TOTAL)),
    stat = "smooth", stat_params = list(),
    position = position_identity()
  ) +
  layer (
    data = join_df_2,
    mapping = (aes(x=YEAR, y=RESP_TOTAL)),
    stat = "smooth", stat_params = list(),
    position = position_identity()
  ) +
  layer (
    data = join_df_2,
    mapping = (aes(x=YEAR, y=PREM_TOTAL)),
    stat = "smooth", stat_params = list(),
    geom = "point", geom_params = list(),
    position = position_identity()
  )
