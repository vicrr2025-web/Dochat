package com.dochat.server.service;

import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

@Service
public class SseService {

    private static final Logger log = LoggerFactory.getLogger(SseService.class);
    private static final Gson GSON = new Gson();
    private static final long SSE_TIMEOUT = 30 * 60 * 1000L; // 30 minutes

    // sessionId -> List of SseEmitter (one per connected user)
    private final ConcurrentHashMap<String, List<SessionEmitter>> sessions = new ConcurrentHashMap<>();

    /**
     * Subscribe a user to a session's SSE stream.
     * Returns an SseEmitter that the controller will return to the client.
     */
    public SseEmitter subscribe(String sessionId, String userId) {
        SseEmitter emitter = new SseEmitter(SSE_TIMEOUT);
        SessionEmitter se = new SessionEmitter(userId, emitter);

        sessions.computeIfAbsent(sessionId, k -> new CopyOnWriteArrayList<>()).add(se);

        // Clean up on completion, timeout, or error
        emitter.onCompletion(() -> removeEmitter(sessionId, se));
        emitter.onTimeout(() -> removeEmitter(sessionId, se));
        emitter.onError(e -> removeEmitter(sessionId, se));

        // Send initial connected event
        try {
            emitter.send(SseEmitter.event()
                    .name("connected")
                    .data(GSON.toJson(Map.of("sessionId", sessionId, "userId", userId))));
        } catch (IOException e) {
            log.error("Failed to send SSE connected event", e);
        }

        log.debug("SSE subscribed: session={}, userId={}, total sessions={}",
                sessionId, userId, sessions.size());
        return emitter;
    }

    /**
     * Send an event to all users subscribed to a session.
     */
    public void sendEvent(String sessionId, String eventType, Object data) {
        List<SessionEmitter> emitters = sessions.get(sessionId);
        if (emitters == null || emitters.isEmpty()) {
            return;
        }

        String json = GSON.toJson(data);
        for (SessionEmitter se : emitters) {
            try {
                se.emitter.send(SseEmitter.event()
                        .name(eventType)
                        .data(json));
            } catch (IOException e) {
                log.debug("SSE send failed for user {} in session {}: removing",
                        se.userId, sessionId);
                removeEmitter(sessionId, se);
            }
        }
    }

    private void removeEmitter(String sessionId, SessionEmitter se) {
        List<SessionEmitter> emitters = sessions.get(sessionId);
        if (emitters != null) {
            emitters.remove(se);
            if (emitters.isEmpty()) {
                sessions.remove(sessionId);
            }
        }
        log.debug("SSE emitter removed: session={}, userId={}", sessionId, se.userId);
    }

    /**
     * Internal record to associate an emitter with a user ID.
     */
    private static class SessionEmitter {
        final String userId;
        final SseEmitter emitter;

        SessionEmitter(String userId, SseEmitter emitter) {
            this.userId = userId;
            this.emitter = emitter;
        }
    }
}
