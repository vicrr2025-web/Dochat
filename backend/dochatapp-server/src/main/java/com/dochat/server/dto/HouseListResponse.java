package com.dochat.server.dto;

import com.dochat.server.model.House;

import java.util.List;

public class HouseListResponse {

    private List<House> houses;
    private int page;
    private int size;
    private long total;

    public HouseListResponse() {}

    public HouseListResponse(List<House> houses, int page, int size, long total) {
        this.houses = houses;
        this.page = page;
        this.size = size;
        this.total = total;
    }

    public List<House> getHouses() { return houses; }
    public void setHouses(List<House> houses) { this.houses = houses; }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }

    public int getSize() { return size; }
    public void setSize(int size) { this.size = size; }

    public long getTotal() { return total; }
    public void setTotal(long total) { this.total = total; }
}
