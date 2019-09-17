library(optparse)
option_list<-list(
  make_option(c("-i","--input"),type = "character",default=FALSE,
              help="the *.sh that need to split"),
  make_option(c("-d","--dir"),type = "character",default=getwd(),
              help="a folder that stores files after spliting *.sh"),
  make_option(c("-l","--line"),type="integer",default = FALSE,
              help="how many lines to split into a file"),
  make_option(c("-m","--maxjob"),type="integer",default = 5,
              help="how many jobs are parallel at a time, maxjob must be less than line"),
  make_option(c("-o","--output"),type="character",default=FALSE,
              help="final output to run later"),
  make_option(c("-p","--pfile"),type="character",default=FALSE,
              help="parallel dir"),
  make_option(c("-r","--rep"),action="store_false",default=FALSE,
              help="ifelse need report")
)
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser)
input=opt$input
dir=opt$dir
line=opt$line
max.parjob=opt$maxjob
output=opt$output
pfile=opt$pfile
rep=opt$rep
system(paste('mkdir -p ',dir,sep=""))
dat<-read.table(input,header=F,sep="\t",quote="")
num=0
for (i in seq(1,nrow(dat),line)){
#for (i in 1:1){
  tmp=dat[i:(i+line-1),]
  num=num+1
  stt=paste("echo start at time ","`","date +%F","' ","'","%H:%M","`",' >> ',dir,"/work_",formatC(num, flag = 0, width = 3),'.log 2>&1',sep='')
  ent=paste("echo finish at time ","`","date +%F","' ","'","%H:%M","`",' >> ',dir,"/work_",formatC(num, flag = 0, width = 3),'.log 2>&1',sep='')
  ntmp=paste(na.omit(tmp),' &&  echo ',"work_",formatC(num, flag = 0, width = 3),'_is_Completed!',' >> ',dir,"/work_",formatC(num, flag = 0, width = 3),'.log 2>&1',sep="")
  #write.table(ntmp,file=paste(dir,"/work_",formatC(num, flag = 0, width = 3),'.sh',sep=""),row.names=F,col.names=F,quote=F)
  ntmp=paste(stt,ntmp,ent,sep="\n")
  #print(ntmp)
  write.table(ntmp,file=paste(dir,"/work_",formatC(num, flag = 0, width = 3),'.sh',sep=""),row.names=F,col.names=F,quote=F)
}
oup=list()
for (i in 1:(ifelse(num%%max.parjob==0,num/max.parjob,(num%/%max.parjob)+1))){
  st=seq(1,num,max.parjob)[i]
  ed=ifelse(is.na(seq(max.parjob,num,max.parjob)[i]),num,seq(max.parjob,num,max.parjob)[i])
  ptmp=paste(pfile,' -j0 ::: ',paste(dir,'/','work_',formatC(c(st:ed), flag = 0, width = 3),'.sh',sep="",collapse = " "),sep="")
  oup=rbind(oup,ptmp)
}
write.table(oup,file=output,quote=F,row.names=F,col.names=F)
system(paste('chmod 700 -R ',dir,sep=""))
