package com.refill;

import com.refill.web.AuthFilter;
import com.refill.web.LoginServlet;
import com.refill.web.RefillRequestServlet;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;
import org.apache.tomcat.util.descriptor.web.FilterDef;
import org.apache.tomcat.util.descriptor.web.FilterMap;

import java.io.File;

public class EmbeddedServer {

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8080"));
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector(); // trigger connector creation

        String webappDir = new File("src/main/webapp").getAbsolutePath();
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir);
        ctx.setParentClassLoader(EmbeddedServer.class.getClassLoader());
        ctx.setReloadable(true);

        File additionWebInfClasses = new File("target/classes");
        WebResourceRoot resources = new StandardRoot(ctx);
        if (additionWebInfClasses.exists()) {
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
        }
        ctx.setResources(resources);

        // Explicitly register servlets and filters to ensure instant deployment
        Tomcat.addServlet(ctx, "loginServlet", new LoginServlet());
        ctx.addServletMappingDecoded("/login", "loginServlet");
        ctx.addServletMappingDecoded("/logout", "loginServlet");

        Tomcat.addServlet(ctx, "refillServlet", new RefillRequestServlet());
        ctx.addServletMappingDecoded("/refills", "refillServlet");

        FilterDef filterDef = new FilterDef();
        filterDef.setFilterName("authFilter");
        filterDef.setFilter(new AuthFilter());
        ctx.addFilterDef(filterDef);

        FilterMap filterMap = new FilterMap();
        filterMap.setFilterName("authFilter");
        filterMap.addURLPatternDecoded("/*");
        ctx.addFilterMap(filterMap);

        System.out.println("=================================================================");
        System.out.println("Refill Tracker Web Application (Task 2: Servlets + JSP)");
        System.out.println("Starting Tomcat on http://localhost:" + port + "/login");
        System.out.println("Press Ctrl+C to stop the server.");
        System.out.println("=================================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
