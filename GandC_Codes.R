###########################
###########################
##                       ##
##  Getting & Clearing   ##
##        data           ##
##                       ##
###########################
###########################

#Controllo se nel path di lavoro esiste o meno la directory
setwd("C:\\Users\\giannetto_sa\\Documents\\data science\\R codes vari\\getting&cleaning")

if (!file.exists("fodler_name")) { #controllo se esite la directory (!--> non esite)
   dir.create("folder_name")       #creo la directory se non esiste
  }
#per scaricare file dalla rete si usa il comando
download.file(url = ,destfile = , method = ) 
#esempio

fileURL<- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileURL,destfile = "./data/cameras.csv") #method="curl" serve per il mac
list.files("data")
dateDonwnloaded<-date()

#Leggo il file scaricato
#Read.table() è la funzione geenrica che richiede paramentri in ingresso
#avrei potuto usare le funzioni read.csv() o read.csv2()

cameraData<-read.table("./data/cameras.csv",sep=",", header = TRUE)
head(cameraData)

##################################################################
# in caso di file excel si procede in maniera simile:            #
##################################################################
#nota: i dati non so più disponibili
if (!file.exists("data")) { dir.create("data")}
fileURL<- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"
download.file(fileURL,destfile = "./data/cameras.xlsx") #method="curl" serve per il mac
dateDonwnloaded<-date()
#istanzio la libreria Xlsx
#se non presente bisogna istallare il pacchetto xlsx
# una libreria alternativa è readxl oppure XLConnect

library(xlsx)
cameraData<-read.xlsx("./data/cameras.xlsx", sheetIndex=1,header=TRUE)

# to read specific components, it's possible to set up cols and rows to read
colIndex<-2:3
rowIndex<-1:4
cameraDataSubset <- read.xlsx("./data/cameras.xlsx", sheetIndex=1,header=TRUE, colIndex=colIndex,rowIndex=rowIndex)


################################################################
#####                  Lettura di file XML                ######
################################################################
library(XML)
fileURL<-"http://www.w3schools.com/xml/simple.xml"
doc<-xmlTreeParse(fileURL,useInternal =TRUE)#useInternal=TRUE

rootNode<-xmlRoot(doc)
names(rootNode)
rootNode[[1]] #seleziono il primo elemento del Nodo
rootNode[[1]][[1]] # seleziono all'interno del primo nodo, il primo sotto elemento
#estrapola in maniera sistematica il contenuto del nodo
xmlSApply(rootNode,xmlValue)
xpathSApply(rootNode,"//name",xmlValue) #su l'intero documento (rootNode) estrae il contenuto del nodo "name"
xpathSApply(rootNode,"//price",xmlValue) #su l'intero documento (rootNode) estrae il contenuto del nodo "price"

#Esempio - Baltimora Ravens
fileURL<-"http://www.espn.com/nfl/team/_/name/bal/baltimore-ravens"
#fileURL<-"C:\\Users\\giannetto_sa\\Documents\\data science\\R codes vari\\getting&cleaning\\ravens_example.html"
doc<-htmlTreeParse(fileURL,useInternalNodes = TRUE)#,useInternal=TRUE
scores<-xpathSApply(doc,"//li[@class='scores']",xmlValue) #estraggo i risultati
teams<-xpathSApply(doc,"//li[@class='team-name']",xmlValue) #estraggo i team
################################################################
#####                 Lettura di file JSON                ######
################################################################
#pacchetto da istallare jsonlite
library(jsonlite)
jsonData<-fromJSON("https://api.github.com/users/jtleek/repos")

#################################################################
## data.table ###################################################
library(data.table)
#metodo classico per creata dataframe
DF=data.frame(x=rnorm(9),Y=rep(c("a","b","c"),each=3),z=rnorm(9))
#con Data.table
DT=data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
# con l'istruzione tables() verifico tutte le tabelle in memoria
DT[,list(mean(x),sum(z))] #seleziono la media di x e la somma della colonna z
DT[,table(y)]
# per aggiungere una nuova colonna calcolata:
DT[,W:=z^2]
#posso creare nuove colonne effettuando più operazioni
DT[,m:={tmp<-(x+z); log2(tmp+5)}]
#posso creare nuove colonne con funzioni logiche
DT[,a:=x>0]
#posso operare con le funzioni di raggruppamento
DT[,b:=mean(x+W), by=a]
###variabile .N è un intero che contiene quante volte si verificano delle occorrenze
set.seed(123)
DT<-data.table(x=sample(letters[1:3],1E5,TRUE)) #creo un campione di esempio con una sola colonna e 100000 righe
DT[,.N,by=x] #.N conta quante occorrenze ho per ciascuna lettera
#####chiavi
DT=data.table(x=rep(c("a","b","c"),each=100),Y=rnorm(300))
setkey(DT,x) #configuro la chiave
DT["a"] #posso sezionale velocemente la tabella
#posso usare le chiavi per mergiare due tabelle
DT1<-data.table(x=c("a","a","b","DT1"),y=1:4)
DT2<-data.table(x=c("a","b","DT2"),z=5:7)
setkey(DT1,x);setkey(DT2,x)
merge(DT1,DT2)

########fast reading###########################################
#creo un dabase grande
big_df=data.frame(x=rnorm(1E6),y=rnorm(1E6))
file<-tempfile()
write.table(big_df,file = file,row.names = FALSE,col.names = TRUE,sep="\t",quote=FALSE)
system.time(fread(file))

system.time(read.table(file,header = TRUE,sep="\t"))

