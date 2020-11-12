package org.zerock.service;

import java.util.List;

import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.Criteria;

//9.1 비지니스 계층의 설정
public interface MemberService {

	//메서드를 설계할 때 메서드 이름은 현실적인 로직의 이름을 붙이는 것이 관례
	
	//Create
	//abstract 추상메소드
	public abstract void register(MemberVO member, AuthVO auth);
	//Read	명백하게 반환해야 할 데이터가 있다(get).
	public MemberVO get(String userid);
	//Update
	public boolean modify(MemberVO member);
	//Delete
	public boolean remove(String userid);
	
	//public List<MemberVO> getList();
	public List<MemberVO> getList(Criteria cri);
	
	public int getTotalCount(Criteria cri);
}
