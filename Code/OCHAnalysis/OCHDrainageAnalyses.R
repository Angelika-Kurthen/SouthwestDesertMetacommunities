###########################################################
## OCH Drainage Analyses
###########################################################
drainage_lm <- data.frame()
drainagelist <- data.frame()
for (i in Drainages){
  for (j in c(2012, 2013)){
    for (k in c("Fall", "Spring")){
      a <- DrainMetacom_Sorted[which(
        (DrainMetacom_Sorted$Drainage == i) & 
          (DrainMetacom_Sorted$DAY.MONTH.YEAR == j) & 
          (DrainMetacom_Sorted$Season == k) &
          is.na(DrainMetacom_Sorted$Site) == F),]
      if (length(a$Drainage) < 1 ){
        g <- "DNE"
      }else{
        b <- as.data.frame(pivot_wider.(a, names_from = Taxa, values_from = Count, id_cols = Site ))
        c <- b[ , -(1)]
        c[is.na(c)] = 0
        d <- as.matrix(c)
        e <- vegdist(d, "chao", na.rm = T)
        f <- as.vector(e)
        g <- mean(f)
      }
      h <- cbind(paste(i), paste(k), paste(j), g)
      drainagelist <- rbind(drainagelist, h)
      n <- cbind(rep(paste(i), length(f)), rep(paste(k), length(f)), rep(paste(j), length(f)), f)
      drainage_lm <- rbind(drainage_lm, n)
    }}}





