package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

//8.1.1 VO 클래스의 작성
@Data
public class NoticeVO {
	private long bno;
	private String title;
    private String content;
    private String writer;
    private Date regdate;
    private Date updatedate;
    
    private int replyCnt;	//댓글수
    private int hit;				//조회수
    
    private String ip;			//ip주소
    
    private List<NoticeAttachVO> attachList;
}
