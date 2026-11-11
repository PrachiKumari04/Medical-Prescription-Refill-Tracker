package com.refill.hibernate;

import com.refill.model.Prescription;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.stat.Statistics;

public class CacheDemo {

    public static void main(String[] args) {
        SessionFactory sf = HibernateUtil.factory();
        Statistics stats = sf.getStatistics();
        stats.clear();
        try {
            try (Session s1 = sf.openSession()) {
                Prescription a = s1.get(Prescription.class, 1);
                Prescription b = s1.get(Prescription.class, 1);
                System.out.println("Session 1: get(1) twice  -> same object: " + (a == b));
            }
            try (Session s2 = sf.openSession()) {
                s2.get(Prescription.class, 1);
                System.out.println("Session 2: get(1)        -> new session, second-level lookup");
            }
            try (Session s3 = sf.openSession()) {
                s3.get(Prescription.class, 1);
                System.out.println("Session 3: get(1)        -> new session, second-level lookup");
            }
            System.out.println();
            System.out.println("SQL statements prepared : " + stats.getPrepareStatementCount());
            System.out.println("L2 cache hits           : " + stats.getSecondLevelCacheHitCount());
            System.out.println("L2 cache misses         : " + stats.getSecondLevelCacheMissCount());
            System.out.println("L2 cache puts           : " + stats.getSecondLevelCachePutCount());
        } finally {
            HibernateUtil.shutdown();
        }
    }
}
