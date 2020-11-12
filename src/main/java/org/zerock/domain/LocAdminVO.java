package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class LocAdminVO {
	private String lat;		//위도
	private String lng;	//경도
    private Date inputDate;
    private String ip;
}
