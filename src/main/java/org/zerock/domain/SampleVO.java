package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

//전달된 객체를 생성하기 위해
@Data
@AllArgsConstructor	//모든 속성을 사용하는 생성자를 위해
@NoArgsConstructor	//비어있는 생성자를 만들기 위해
public class SampleVO {

	private Integer mno;
	private String firstName;
	private String lastName;
}
