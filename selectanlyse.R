library(cowplot)
#library(magrittr)
library(ggplot2)
library(scales)
library(gtable)

#fileheader = "fst_pi/"
#filetail = "_vs_N.fst_pi"
#namelist <- c("GFA","GFB","GFC","GFD")
#p_divide = 0.05
fileheader = "./"
filetail = ".fst_pi"
namelist <- c("YZ_vs_DH","DH_vs_ZJ","YZ_vs_ZJ")
p_divide = 0.05
divid_percent <- function(x,p) {
  temp <- round(length(x)*(p))
  return(sort(x)[temp])
}

for (group in namelist) {
  path <- paste0(fileheader,group,filetail)
  test1 <- paste0("S_S_",group," <- na.omit( read.table(file = path,header = T,fill = T))")
  eval(str2expression(test1))
}


for (group in namelist) {
  


name <- paste0("S_S_",group)
eval(str2expression(paste0("target <- ",name)))


sameRangey <- range(target$fst)+c(-min(target$fst),0.01)
sameRangex <- range(target$log2.pi_a.pi_b.)+c(-1,1)

vleft_divide <-   divid_percent(target$log2.pi_a.pi_b.,p_divide)
vright_divide <- divid_percent(target$log2.pi_a.pi_b.,1-p_divide)
h_divide <- divid_percent(target$fst,1-p_divide)

##skip plotting
plot_main <- ggplot(target,mapping = aes(x = `log2.pi_a.pi_b.`,y = fst))+geom_point()+
theme_classic()+geom_vline(aes(colour ='red',xintercept =  vleft_divide), linetype = 1)+geom_hline(aes(colour ='red',yintercept = h_divide),linetype = 1)+geom_vline(aes(colour ='red',xintercept =  vright_divide), linetype = 1)+
theme(legend.position='none')+theme(plot.margin=unit(c(0,0,0,1),"cm"))+
coord_cartesian(xlim=sameRangex,ylim=sameRangey)+scale_y_continuous(expand = c(0,0))
# 1. Prepare the plot
plot_up <- ggplot(target,aes(`log2.pi_a.pi_b.`,after_stat(count / sum(count)))) +  geom_density(color = "gray", fill = "gray",size = 0)
# 2. Get the max value of Y axis as calculated in the previous step
maxPlotY <- max(ggplot_build(plot_up)$data[[1]]$y)
# 3. Overlay scaled ECDF and add secondary axis dont change y
plot_up1 <- plot_up +
stat_ecdf(aes(y=..y..*maxPlotY)) +
scale_y_continuous(name = "Frequency",labels = percent,expand = c(0,0),breaks = seq(0.25*signif(maxPlotY,digits = 1),signif(maxPlotY,digits = 1),0.25*signif(maxPlotY,digits = 1)), sec.axis = sec_axis(
trans = ~./maxPlotY, labels = percent,breaks = seq(0.2,0.8,0.2))
)+
theme_classic()+
theme(axis.text.x=element_blank()
,axis.ticks.x=element_blank()
,axis.title.x=element_blank())+
xlab(NULL)+
coord_cartesian(xlim=sameRangex)+
theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
plot_up <- plot_up +
stat_ecdf(aes(y=..y..*maxPlotY)) +
scale_y_continuous(name = "Frequency",labels = percent,expand = c(0,0),
breaks = seq(0.25*signif(maxPlotY,digits = 1),signif(maxPlotY,digits = 1),0.25*signif(maxPlotY,digits = 1))
#sec.axis = sec_axis(
#   trans = ~./maxPlotY, labels = percent,breaks = seq(0.2,0.8,0.2))
)+
theme_classic()+
theme(axis.text.x=element_blank()
,axis.ticks.x=element_blank()
,axis.title.x=element_blank())+
xlab(NULL)+
coord_cartesian(xlim=sameRangex)+
theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
# 1. Prepare the plot
plot_right <-ggplot(target,aes(`fst`,after_stat(count / sum(count))))+geom_density(color = "gray", fill = "gray",size = 0)
# 2. Get the max value of Y axis as calculated in the previous step
maxPlotY2 <- max(ggplot_build(plot_right)$data[[1]]$y)
# 3. Overlay scaled ECDF and add secondary axis dont change y
plot_right <- plot_right +
theme_classic()+
stat_ecdf(aes(y=..y..*maxPlotY2)) +
scale_y_continuous(expand = c(0,0),name = "Frequency",labels = percent,
breaks = seq(0.25*signif(maxPlotY2,digits = 1),signif(maxPlotY2,digits = 1),0.25*signif(maxPlotY2,digits = 1))
#, sec.axis = sec_axis(trans = ~./maxPlotY, name = "ECDF",labels = percent)
)+theme(axis.title.y=element_blank(),
axis.text.y=element_blank(),
axis.ticks.y=element_blank())+
theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))+
coord_flip()
plot_right1 <- plot_right+scale_y_continuous(expand = c(0,0),name = "Frequency",breaks = seq(0.2, 0.8, 0.2),sec.axis = sec_axis(trans = ~./maxPlotY2,name = "  Cumulative (%)",labels = percent,breaks = seq(0.2, 0.8, 0.2)))
tplotup <- ggplotGrob(plot_up1)
tt <- gtable_filter(tplotup,"axis-r|ylab-r|layout")
tplotright <- ggplotGrob(plot_right1)
rr <- gtable_filter(tplotright,"xlab-t|axis-t")
null <- ggplot()+theme_void()
a  <- cowplot::plot_grid(plot_up,null,plot_main,null,axis="tblr",align="v"
,rel_widths=c(0.7,0.3),rel_heights=c(0.3,0.7))
b  <- cowplot::plot_grid(null,null,plot_main,plot_right,axis="tblr",align="h"
,rel_widths=c(0.7,0.3),rel_heights=c(0.3,0.7))
#g <- ggdraw(a)+draw_plot(tt,x = 0.735,y = 0.7,width = 0,height = 0.3)+  draw_plot(b)+draw_plot(rr,x = 0.7,y = 0.708,width = 0.3,height = 0.1)
#ggsave(paste0(group,"_selectiveSweep.png"),g,width = 5,height = 3,units = "in")
g <- ggdraw(a)+draw_plot(tt,x = 0.725,y = 0.7,width = 0,height = 0.3)+
draw_plot(b)+draw_plot(rr,x = 0.7,y = 0.695,width = 0.3,height = 0.1)
ggsave(paste0(fileheader,group,filetail,"_selectiveSweep.png"),g,width = 8,height = 5,units = "in")


selected_gene_T <- subset.data.frame(target,target$fst>h_divide)
selected_gene_LT <- subset.data.frame(selected_gene_T,selected_gene_T$log2.pi_a.pi_b.<vleft_divide)[,c(1:3,7:10)]
selected_gene_RT <- subset.data.frame(selected_gene_T,selected_gene_T$log2.pi_a.pi_b.>vright_divide)[,c(1:3,7:10)]

write.table(selected_gene_LT,file = paste0(fileheader,group,filetail,"_selected_gene_LT.txt"),quote = F,row.names = F,col.names = T,sep = '\t')
write.table(selected_gene_RT,file = paste0(fileheader,group,filetail,"_selected_gene_RT.txt"),quote = F,row.names = F,col.names = T,sep = '\t')

}



