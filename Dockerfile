FROM tomcat:10.1-jdk21-temurin

# Remove default Tomcat web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your built WAR application as the root application (ROOT.war)
COPY dist/wt-project_own_.war /usr/local/tomcat/webapps/ROOT.war

# Expose default port
EXPOSE 8080

# Disable Tomcat shutdown port & dynamically adapt HTTP port to $PORT, then start Tomcat
CMD ["sh", "-c", "sed -i 's/<Server port=\"8005\"/<Server port=\"-1\"/' /usr/local/tomcat/conf/server.xml; if [ -n \"$PORT\" ]; then sed -i \"s/port=\\\"8080\\\"/port=\\\"$PORT\\\"/g\" /usr/local/tomcat/conf/server.xml; fi; exec catalina.sh run"]
