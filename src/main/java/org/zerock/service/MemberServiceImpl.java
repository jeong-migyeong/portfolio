package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.MemberMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@AllArgsConstructor	//모든 파라미터를 이용하는 생성자를 만듦
@Service	//계층 구조상 주로 비즈니스 영역을 담당하는 객체임을 표시하기 위해 사용
public class MemberServiceImpl implements MemberService {
	
	//spring 4.3 이상에서 자동 처리
	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;

	//Create
	@Transactional		//쿼리를 2개 사용한다는 뜻(?)
	@Override
	public void register(MemberVO member, AuthVO auth) {
		//9.2.1 등록 작업의 구현과 테스트
		//insertSelectKey를 이용해서 나중에 생성된 게시물의 번호를 확인할 수 있다.
		mapper.insertSelectKey(member);
		mapper.insertAuth(auth);
	}

	//Read
	@Transactional
	@Override
	public MemberVO get(String userid) {
		//조회는 게시물의 번호가 파라미터
		//MemberVO의 인스턴스가 리턴
		return mapper.read(userid);
	}

	//Update
	@Override
	public boolean modify(MemberVO member) {
		//9.2.4 삭제/수정 구현과 테스트
		//엄격하게 처리하기 위해서 리턴 타입을 Boolean으로 처리
		//정상적으로 수정이 이루어지면 1이라는 값이 반환되기 때문에 '=='연산자를 이용해서 true/false를 처리
		return mapper.update(member) == 1;
	}

	//Delete
	@Override
	public boolean remove(String userid) {
		//9.2.4 삭제/수정 구현과 테스트
		//엄격하게 처리하기 위해서 리턴 타입을 Boolean으로 처리
		//정상적으로 삭제가 이루어지면 1이라는 값이 반환되기 때문에 '=='연산자를 이용해서 true/false를 처리
		return mapper.remove(userid) == 1;
	}

	//현재 테이블에 저장된 모든 데이터를 가져오는 getList()
	/*
	 * @Override public List<MemberVO> getList() { // 9.2.2 목록(리스트) 작업의 구현과 테스트
	 * return mapper.getList(); }
	 */

	public List<MemberVO> getList(Criteria cri){
		log.info("get List with vriteria: " + cri);
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotalCount(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	
}
