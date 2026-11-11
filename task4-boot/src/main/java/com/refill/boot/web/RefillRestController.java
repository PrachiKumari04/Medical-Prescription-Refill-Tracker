package com.refill.boot.web;

import com.refill.boot.dto.NewRefillRequest;
import com.refill.boot.dto.RefillResponse;
import com.refill.boot.service.RefillService;
import com.refill.model.RefillStatus;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/api")
public class RefillRestController {

    private final RefillService service;

    public RefillRestController(RefillService service) {
        this.service = service;
    }

    @GetMapping("/refills")
    public ResponseEntity<List<RefillResponse>> list(@RequestParam(name = "status", required = false) RefillStatus status) {
        return ResponseEntity.ok(service.getAll(status));
    }

    @GetMapping("/refills/{id}")
    public ResponseEntity<RefillResponse> getById(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(service.getById(id));
    }

    @PostMapping("/refills")
    public ResponseEntity<RefillResponse> create(@Valid @RequestBody NewRefillRequest request) {
        RefillResponse created = service.submit(request);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(created.id())
                .toUri();
        return ResponseEntity.created(location).body(created);
    }

    @PatchMapping("/refills/{id}/approve")
    public ResponseEntity<RefillResponse> approve(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(service.approve(id));
    }

    @PatchMapping("/refills/{id}/reject")
    public ResponseEntity<RefillResponse> reject(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(service.reject(id));
    }

    @PatchMapping("/refills/{id}/collect")
    public ResponseEntity<RefillResponse> collect(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(service.collect(id));
    }

    @GetMapping("/patients/{patientId}/refills")
    public ResponseEntity<List<RefillResponse>> patientRefills(@PathVariable("patientId") Integer patientId) {
        return ResponseEntity.ok(service.getByPatientId(patientId));
    }

    @DeleteMapping("/refills/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Integer id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}

