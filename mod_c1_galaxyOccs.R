galaxyOccs_UI <- function(id) {
  ns <- NS(id)
  python.load("/x.py")
  x <- python.call("x")
  v<-list()
  l<-length(x)
  for (y in 1:l) {
        if(x[[y]]$'extension' == 'csv'){
            name<-paste(x[[y]]$'hid',x[[y]]$'name')
            id<-unname(x[[y]]$'hid')
            v[[name]]<-id
        }
  }
  tagList(
    tags$div(title='Galaxy portal.',
             selectInput(ns("userCSV"), label = "Select from your Galaxy History User csv file",
                choices = v))
         )

  }	
