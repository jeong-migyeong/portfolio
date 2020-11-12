package org.zerock.service;

import java.util.List;

import org.zerock.domain.NoticeVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.NoticeAttachVO;

//9.1 비지니스 계층의 설정
public interface NoticeService {

	//메서드를 설계할 때 메서드 이름은 현실적인 로직의 이름을 붙이는 것이 관례
	
	//Create
	//abstract 추상메소드
	public abstract void register(NoticeVO board);
	//Read	명백하게 반환해야 할 데이터가 있다(get).
	public NoticeVO get(long bno);
	//Update
	public boolean modify(NoticeVO board);
	//Delete
	public boolean remove(long bno);
	
	//public List<NoticeVO> getList();
	public List<NoticeVO> getList(Criteria cri);
	
	//첨부파일
	public List<NoticeAttachVO> getAttachList(long bno);
	
	public int getTotal(Criteria cri);
}
