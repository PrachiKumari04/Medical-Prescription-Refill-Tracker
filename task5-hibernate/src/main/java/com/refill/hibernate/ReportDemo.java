package com.refill.hibernate;

import com.refill.model.RefillStatus;

import java.time.LocalDate;

public class ReportDemo {

    public static void main(String[] args) {
        RefillHibernateDao dao = new RefillHibernateDao();
        try {
            System.out.println("HQL approvedPerPatient(1):");
            for (Object[] row : dao.approvedPerPatient(1)) {
                System.out.println("  " + row[0] + " -> " + row[1]);
            }
            System.out.println();
            System.out.println("Criteria search(null, PENDING, null, null):");
            dao.search(null, RefillStatus.PENDING, null, null).forEach(r -> System.out.println("  " + r));

            System.out.println();
            System.out.println("Criteria search(\"ravi\", null, 2026-10-01, 2026-10-31):");
            dao.search("ravi", null, LocalDate.of(2026, 10, 1), LocalDate.of(2026, 10, 31))
               .forEach(r -> System.out.println("  " + r));
        } finally {
            HibernateUtil.shutdown();
        }
    }
}

