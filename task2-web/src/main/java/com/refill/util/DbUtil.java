package com.refill.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;

public final class DbUtil {

    private static final HikariDataSource DS;

    static {
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(System.getProperty("db.url",
                "jdbc:mysql://localhost:3306/refill_db?useSSL=false&serverTimezone=Asia/Kolkata&allowPublicKeyRetrieval=true"));
        cfg.setUsername(System.getProperty("db.user", "root"));
        cfg.setPassword(System.getProperty("db.password", "root"));
        cfg.setMaximumPoolSize(10);
        cfg.setMinimumIdle(2);
        cfg.setConnectionTimeout(10_000);
        cfg.setPoolName("RefillPool");
        cfg.addDataSourceProperty("cachePrepStmts", "true");
        cfg.addDataSourceProperty("prepStmtCacheSize", "250");
        DS = new HikariDataSource(cfg);
    }

    private DbUtil() {
    }

    public static DataSource getDataSource() {
        return DS;
    }

    public static Connection getConnection() throws SQLException {
        return DS.getConnection();
    }

    public static void shutdown() {
        if (!DS.isClosed()) {
            DS.close();
        }
        try {
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Throwable ignored) {
        }
    }
}
