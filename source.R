library(RCurl)
library(dplyr)
library(networkD3)
print('source loaded')

episodes = list(
  "https://raw.githubusercontent.com/jnt0009/Bachelor/master/bachelor_subtitles/data/episode01.csv",
  "https://raw.githubusercontent.com/jnt0009/Bachelor/master/bachelor_subtitles/data/episode02.csv",
  "https://raw.githubusercontent.com/jnt0009/Bachelor/master/bachelor_subtitles/data/episode03.csv",
  "https://raw.githubusercontent.com/jnt0009/Bachelor/master/bachelor_subtitles/data/episode04.csv",
  "https://raw.githubusercontent.com/jnt0009/Bachelor/master/bachelor_subtitles/data/episode05.csv"
)
  
ladies = getURL('https://raw.githubusercontent.com/jnt0009/Bachelor/master/bachelor_subtitles/data/bachelorettes.csv')
ladies = read.csv(text = ladies)
ladies = data.table::setDT(ladies, keep.rownames = TRUE)[]
ladies$rn = tolower(ladies$rn)
pics = list(
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279924/35ac91fbb3fb061de93c914c9341c32a/1000x400-Q90_35ac91fbb3fb061de93c914c9341c32a.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279874/85a64dcb08a29a74aaceebdea6e89ff4/1000x400-Q90_85a64dcb08a29a74aaceebdea6e89ff4.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279923/a2a73b2af26630fd59af20e58c8ff2ca/1000x400-Q90_a2a73b2af26630fd59af20e58c8ff2ca.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279922/5f9130a56657aef63a4bbc6ea50a4826/1000x400-Q90_5f9130a56657aef63a4bbc6ea50a4826.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279921/a300ed2ddb350bd0d6c4f3a6b247dad6/1000x400-Q90_a300ed2ddb350bd0d6c4f3a6b247dad6.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279916/6db8529ca2a1bb29ae424743060d0cbc/1000x400-Q90_6db8529ca2a1bb29ae424743060d0cbc.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279915/802cf8dcabfcda35d2bc69271b624241/1000x400-Q90_802cf8dcabfcda35d2bc69271b624241.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279914/d882a573ac26ff1705ca8257903b49ff/1000x400-Q90_d882a573ac26ff1705ca8257903b49ff.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279912/4920ab713436fc86ee4fe53b7c52ff1b/1000x400-Q90_4920ab713436fc86ee4fe53b7c52ff1b.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279911/610e0ae9fd1bb99e06659a0c5c347627/1000x400-Q90_610e0ae9fd1bb99e06659a0c5c347627.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279910/1c1869345740daa3b04c8d1ceea7c852/1000x400-Q90_1c1869345740daa3b04c8d1ceea7c852.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279909/359f00a357b74fb6678dbf88b3773367/1000x400-Q90_359f00a357b74fb6678dbf88b3773367.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279908/18a841da6f12ab9a3da079966ab59f1b/1000x400-Q90_18a841da6f12ab9a3da079966ab59f1b.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279906/6811e3d688023dd5995690bb4a3e5465/1000x400-Q90_6811e3d688023dd5995690bb4a3e5465.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279905/2a5c4ec4a1fbf4901861031846520584/1000x400-Q90_2a5c4ec4a1fbf4901861031846520584.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279904/dfa1b5a88eca200e63dcc0225748b142/1000x400-Q90_dfa1b5a88eca200e63dcc0225748b142.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279903/03713eb10daf7cbd59fbeebf270446cb/1000x400-Q90_03713eb10daf7cbd59fbeebf270446cb.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279902/450af579c6534f17a9f474d1e0f6eb18/1000x400-Q90_450af579c6534f17a9f474d1e0f6eb18.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279901/0bedf0037c21f9e6d1b619a57fcec760/1000x400-Q90_0bedf0037c21f9e6d1b619a57fcec760.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279897/8d5eeb4ae4df01ab7c281ff486ed77c7/1000x400-Q90_8d5eeb4ae4df01ab7c281ff486ed77c7.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279894/663b2d0adb36af97464690ebc3760f0a/1000x400-Q90_663b2d0adb36af97464690ebc3760f0a.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279893/9082db16f2da7d96ece0b9beeb4c50cc/1000x400-Q90_9082db16f2da7d96ece0b9beeb4c50cc.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279892/7f86bfababdd25ce1d39932e09027fda/1000x400-Q90_7f86bfababdd25ce1d39932e09027fda.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279891/532b34e5388a604555053639eba57329/1000x400-Q90_532b34e5388a604555053639eba57329.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279887/11b2a11d4c0471c3b3b439e9bbc729d8/1000x400-Q90_11b2a11d4c0471c3b3b439e9bbc729d8.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279886/f457b87f1c31395eec83e8d2ad70673d/1000x400-Q90_f457b87f1c31395eec83e8d2ad70673d.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279884/31c1cac25fa03d9448ca9850e9884708/1000x400-Q90_31c1cac25fa03d9448ca9850e9884708.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279882/15dc057dd568036af6435927fc4ec928/1000x400-Q90_15dc057dd568036af6435927fc4ec928.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279878/aef029ffe58c1e9b0812f5a5d873c209/1000x400-Q90_aef029ffe58c1e9b0812f5a5d873c209.jpg",
  "https://cdn1.edgedatg.com/aws/v2/abc/TheBachelor/person/2279876/facab09010a008c6d04ddea0ac2d67aa/1000x400-Q90_facab09010a008c6d04ddea0ac2d67aa.jpg"
)
pics <- t(as.data.frame(pics)) 
ladies$pic <- pics

#roster = RCurl::getURL('https://raw.githubusercontent.com/kmcelwee/TheBachelor/master/data/bachelorettes.csv')
#roster.df = read.csv(text = roster)
#roster.df = data.table::setDT(roster.df, keep.rownames = TRUE)[]
#roster.df$rn <- tolower(roster.df$rn) 



