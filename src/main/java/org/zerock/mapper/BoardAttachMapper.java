package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {

	public void insert(BoardAttachVO vo);
	
	public void delete(String uuid);
	
	public void deleteAll(long bno);
	
	/* 특정 게시물의 번호로 첨부파일을 찾는 작업이 필요하기 때문에 findByBno() 메서드를 정의 */
	public List<BoardAttachVO> findByBno(long bno);
	
	/* 첨부파일 목록을 가져오는 메소드 */
	public List<BoardAttachVO> getOldFiles();
}
