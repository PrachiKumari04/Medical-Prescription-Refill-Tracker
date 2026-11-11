package com.refill;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class EmbeddedServer {

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getProperty("server.port", "8082"));
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector();

        String webappDir = new File("src/main/webapp").getAbsolutePath();
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir);
        ctx.setReloadable(true);

        File additionWebInfClasses = new File("target/classes");
        WebResourceRoot resources = new StandardRoot(ctx);
        if (additionWebInfClasses.exists()) {
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
        }
        ctx.setResources(resources);

        System.out.println("=================================================================");
        System.out.println("Spring MVC + JPA Refill Module (Task 3)");
        System.out.println("Starting Tomcat on http://localhost:" + port + "/pharmacist/refills");
        System.out.println("Patient portal:    http://localhost:" + port + "/patients/1/refills");
        System.out.println("Press Ctrl+C to stop the server.");
        System.out.println("=================================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}

