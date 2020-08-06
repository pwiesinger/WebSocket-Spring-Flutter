package com.lab73.socketexample.data;

import lombok.Data;

@Data
public class HelloMessage {
    private String name;

    public HelloMessage(String name) {
        this.name = name;
    }

    public HelloMessage() {}
}
