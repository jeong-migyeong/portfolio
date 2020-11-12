package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

	//생성자를 정의
	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	//Criteria와 전체 데이터 수(total)를 파라미터로 지정
	//Criteria 안에는 페이지를 보여주는 데이터 수(amount)와 현재 페이지 번호(pageNum)를 가지고 있음
	private int total;
	private Criteria cri;
	
	
	public PageDTO(Criteria cri, int total) {
		this.cri = cri;
		this.total = total;
		
		//페이징 끝번호(endPage) 계산
		this.endPage = (int)(Math.ceil(cri.getPageNum() / 10.0)) * 10;
		//페이징 시작번호(startPage) 계산
		this.startPage = this.endPage - 9;
		
		//total을 이용한 페이징 끝번호(endPage) 계산
		int realEnd = (int)(Math.ceil((total * 10) / cri.getAmount()));
		if(realEnd < this.endPage){
			this.endPage = realEnd;
		}
		
		//이전(prev) 계산
		this.prev = this.startPage > 1;
		//다음(next) 계산
		this.next = this.endPage < realEnd;
	}
	
	
}
