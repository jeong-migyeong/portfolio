package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.NoticeAttachVO;
import org.zerock.domain.NoticeVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.NoticeAttachMapper;
import org.zerock.mapper.NoticeMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@AllArgsConstructor	//모든 파라미터를 이용하는 생성자를 만듦
@Service	//계층 구조상 주로 비즈니스 영역을 담당하는 객체임을 표시하기 위해 사용
public class NoticeServiceImpl implements NoticeService {
	
	//spring 4.3 이상에서 자동 처리
	@Setter(onMethod_ = @Autowired)
	private NoticeMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private NoticeAttachMapper attachMapper;

	//Create
	@Transactional
	@Override
	public void register(NoticeVO board) {
		//insertSelectKey를 이용해서 나중에 생성된 게시물의 번호를 확인할 수 있다.
		mapper.insertSelectKey(board);
		
		//첨부파일이 없으면 return
		if(board.getAttachList() == null || board.getAttachList().size() <=0) {
			return;
		}
		
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());	//bno값 초기화
			attachMapper.insert(attach);	//첨부파일 insert
		});
	}

	//Read
	@Transactional
	@Override
	public NoticeVO get(long bno) {
		//9.2.3 조회 작업의 구현과 테스트
		//조회는 게시물의 번호가 파라미터
		//NoticeVO의 인스턴스가 리턴
		mapper.boardHit(bno);
		return mapper.read(bno);
	}

	//Update
	//엄격하게 처리하기 위해서 리턴 타입을 Boolean으로 처리
	@Transactional
	@Override
	public boolean modify(NoticeVO board) {
		attachMapper.deleteAll(board.getBno());
		boolean modifyResult = mapper.update(board) == 1;
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	//Delete
	@Transactional
	@Override
	public boolean remove(long bno) {
		attachMapper.deleteAll(bno);
		//엄격하게 처리하기 위해서 리턴 타입을 Boolean으로 처리
		//정상적으로 삭제가 이루어지면 1이라는 값이 반환되기 때문에 '=='연산자를 이용해서 true/false를 처리
		return mapper.delete(bno) == 1;
	}

	//현재 테이블에 저장된 모든 데이터를 가져오는 getList()
	/*
	 * @Override public List<NoticeVO> getList() { // 9.2.2 목록(리스트) 작업의 구현과 테스트
	 * return mapper.getList(); }
	 */

	public List<NoticeVO> getList(Criteria cri){
		log.info("get List with vriteria: " + cri);
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	
	@Override
	public List<NoticeAttachVO> getAttachList(long bno) {
		log.info("get Attacj list by bno " + bno);
		return attachMapper.findByBno(bno);
	}
	
}
