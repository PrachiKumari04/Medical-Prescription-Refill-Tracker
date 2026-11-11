package com.refill.boot.web;

import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class RefillRestControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @Order(1)
    void testT4_1_CreateRefillSuccess() throws Exception {
        // T4.1: POST /api/refills with {"patientId":4,"prescriptionId":5}
        // Expected: 201 Created with Location header; status PENDING
        mockMvc.perform(post("/api/refills")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"patientId\":4,\"prescriptionId\":5}"))
                .andExpect(status().isCreated())
                .andExpect(header().exists("Location"))
                .andExpect(jsonPath("$.status").value("PENDING"))
                .andExpect(jsonPath("$.medicineName").value("Salbutamol Inhaler"))
                .andExpect(jsonPath("$.patientName").value("Priya Patil"));
    }

    @Test
    @Order(2)
    void testT4_2_CreateDuplicateRefillConflict() throws Exception {
        // T4.2: Same POST again -> 409 Conflict
        mockMvc.perform(post("/api/refills")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"patientId\":4,\"prescriptionId\":5}"))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.status").value(409))
                .andExpect(jsonPath("$.message").value(containsString("already pending")));
    }

    @Test
    @Order(3)
    void testT4_3_CreateRefillEmptyBodyBadRequest() throws Exception {
        // T4.3: POST with empty body {} -> 400 Bad Request with fieldErrors
        mockMvc.perform(post("/api/refills")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.fieldErrors.patientId").exists())
                .andExpect(jsonPath("$.fieldErrors.prescriptionId").exists());
    }

    @Test
    @Order(4)
    void testT4_4_ApproveAndCollectRefill() throws Exception {
        // T4.4: PATCH /api/refills/2/approve -> 200 APPROVED; then PATCH /api/refills/2/collect -> 200 COLLECTED
        mockMvc.perform(patch("/api/refills/2/approve"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(2))
                .andExpect(jsonPath("$.status").value("APPROVED"));

        mockMvc.perform(patch("/api/refills/2/collect"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(2))
                .andExpect(jsonPath("$.status").value("COLLECTED"));
    }

    @Test
    @Order(5)
    void testT4_5_ApproveRefillWithZeroRemainingConflict() throws Exception {
        // T4.5: PATCH /api/refills/3/approve (prescription 2 has 3 of 3 used) -> 409 Conflict
        mockMvc.perform(patch("/api/refills/3/approve"))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.status").value(409))
                .andExpect(jsonPath("$.message").value(containsString("No refills remaining")));
    }

    @Test
    @Order(6)
    void testT4_6_GetNonExistentRefillNotFound() throws Exception {
        // T4.6: GET /api/refills/99 -> 404 Not Found
        mockMvc.perform(get("/api/refills/99"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.message").value(containsString("not found")));
    }
}
