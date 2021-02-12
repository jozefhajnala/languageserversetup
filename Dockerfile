FROM jozefhajnala/devr

# Clone the repo into RStudio's home for fast development
RUN git clone \
      https://github.com/jozefhajnala/languageserversetup \
      /home/rstudio/languageserversetup \
 && chown rstudio:rstudio /home/rstudio/languageserversetup -R \
 && R CMD INSTALL /home/rstudio/languageserversetup
