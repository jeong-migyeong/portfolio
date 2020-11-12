package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {

	private int pageNum;
	private int amount;
	
	//검색을 위한 type, keyword 변수 추가
	private String type;
	private String keyword;
	
	//기본값 1페이지 10개
	public Criteria() {
		this(1,10);
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	/* getTypeArr은 검색조건이 각 글자(T, W, C)로 구성되어 있으므로 검색조건을 배열로 만들어서 한번에 처리하기 위함
	 * getTypeArr()을 이용해서 MyBatis의 동적 태그를 활용할 수 있다. */
	public String[] getTypeArr() {
		return type == null ? new String[] {} : type.split("");
	}
	
	/* UriComponenetsBuilder는 여러 개의 파라미터들을 연결해서 URL의 형태로 만들어주는 기능 */
	/* 링크를 생성하는 기능 */
	/* UriComponenetsBuilder는 queryParam()이라는 메서드를 이용해서 필요한 파라미터들을 손쉽게 추가 할 수 있다. */
	/* 한글 처리는 신경쓰지 않아도 된다. */
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		return builder.toUriString();
	}
}
