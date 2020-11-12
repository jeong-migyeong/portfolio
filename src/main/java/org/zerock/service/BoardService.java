package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

//9.1 비지니스 계층의 설정
public interface BoardService {

	//메서드를 설계할 때 메서드 이름은 현실적인 로직의 이름을 붙이는 것이 관례
	
	//Create
	//abstract 추상메소드
	public abstract void register(BoardVO board);
	//Read	명백하게 반환해야 할 데이터가 있다(get).
	public BoardVO get(long bno);
	//Update
	public boolean modify(BoardVO board);
	//Delete
	public boolean remove(long bno);
	
	//public List<BoardVO> getList();
	public List<BoardVO> getList(Criteria cri);
	
	//첨부파일
	public List<BoardAttachVO> getAttachList(long bno);
	
	public int getTotal(Criteria cri);
}
