package com.refill.dao;

import com.refill.model.Patient;
import com.refill.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

    public List<Patient> findAll() throws SQLException {
        List<Patient> list = new ArrayList<>();
        String sql = "SELECT patient_id, name, phone FROM patient ORDER BY patient_id";
        try (Connection c = DbUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Patient(
                        rs.getInt("patient_id"),
                        rs.getString("name"),
                        rs.getString("phone")
                ));
            }
        }
        return list;
    }
}
