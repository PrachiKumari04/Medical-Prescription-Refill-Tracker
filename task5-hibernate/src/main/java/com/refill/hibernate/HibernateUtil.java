package com.refill.hibernate;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public final class HibernateUtil {

    private static final SessionFactory FACTORY = build();

    private HibernateUtil() {
    }

    private static SessionFactory build() {
        try {
            return new Configuration().configure("hibernate.cfg.xml").buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory factory() {
        return FACTORY;
    }

    public static void shutdown() {
        if (FACTORY != null && !FACTORY.isClosed()) {
            FACTORY.close();
        }
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Throwable ignored) {
        }
    }
}
