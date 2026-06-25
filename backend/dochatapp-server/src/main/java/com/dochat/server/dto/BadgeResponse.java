package com.dochat.server.dto;

import com.dochat.server.model.EcosystemBadge;

import java.util.Map;

public class BadgeResponse {

    private String ecosystemKey;
    private String ecosystemName;
    private String iconName;
    private int badgeCount;
    private String route;

    public BadgeResponse() {}

    public BadgeResponse(EcosystemBadge badge, Map<String, EcosystemInfo> ecoMap) {
        this.ecosystemKey = badge.getEcosystemKey();
        this.badgeCount = badge.getBadgeCount();
        EcosystemInfo info = ecoMap.get(badge.getEcosystemKey());
        if (info != null) {
            this.ecosystemName = info.name;
            this.iconName = info.iconName;
            this.route = info.route;
        }
    }

    public BadgeResponse(String ecosystemKey, EcosystemInfo info) {
        this.ecosystemKey = ecosystemKey;
        this.badgeCount = 0;
        if (info != null) {
            this.ecosystemName = info.name;
            this.iconName = info.iconName;
            this.route = info.route;
        }
    }

    public String getEcosystemKey() { return ecosystemKey; }
    public void setEcosystemKey(String ecosystemKey) { this.ecosystemKey = ecosystemKey; }

    public String getEcosystemName() { return ecosystemName; }
    public void setEcosystemName(String ecosystemName) { this.ecosystemName = ecosystemName; }

    public String getIconName() { return iconName; }
    public void setIconName(String iconName) { this.iconName = iconName; }

    public int getBadgeCount() { return badgeCount; }
    public void setBadgeCount(int badgeCount) { this.badgeCount = badgeCount; }

    public String getRoute() { return route; }
    public void setRoute(String route) { this.route = route; }

    public static class EcosystemInfo {
        public final String name;
        public final String iconName;
        public final String route;

        public EcosystemInfo(String name, String iconName, String route) {
            this.name = name;
            this.iconName = iconName;
            this.route = route;
        }
    }
}
