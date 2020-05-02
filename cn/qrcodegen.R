library(qrencoder)

url <- "https://gisersqdai.top/mycv/"
head(qrencode(url))

png("qrcodeCV.png", width=8, height=8, units="in", res = 300)
image(qrencode_raster(url), 
      asp=1, col=c("white", "black"), axes=FALSE, 
      xlab="", ylab="")
dev.off()
