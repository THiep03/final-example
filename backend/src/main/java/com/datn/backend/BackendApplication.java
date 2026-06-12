package com.datn.backend;

import com.datn.backend.utils.LogUtils;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.core.env.Environment;

import java.util.HashMap;
import java.util.Map;

@SpringBootApplication
public class BackendApplication {

	public static void main(String[] args) {
        SpringApplication app = new SpringApplication(BackendApplication.class);
        Map<String, Object> defProperties = new HashMap<>();
        defProperties.put("spring.profiles.default", "dev");
        app.setDefaultProperties(defProperties);
        Environment env = app.run(args).getEnvironment();
        LogUtils.logApplicationStartup(env);
	}

}
