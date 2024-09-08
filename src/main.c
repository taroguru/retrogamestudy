#include "ubox.h"
//reference : https://www.usebox.net/jjm/ubox-msx-lib/ubox-lib-ref.html

#define LOCAL
#include "tiles.h"

//??
#define WHITESPACE_TILE 129

//한줄 쓰기. x, y 시작 좌표
void put_text(uint8_t x, uint8_t y, const uint8_t *text){
    while(*text){       
        ubox_put_tile(x++, y, *text++ + 128 - 31);
    }
}





void main()
{
    
    //초당 프레임 30으로 지정
    ubox_init_isr(2);   
    // 화면을 스크린 모드2 로 설정
    ubox_set_mode(2);
    //화면을 검은색으로 초기화
    //foreground, background, border
    ubox_set_colors(1,1,1);
    
    //초기화 로직 사이에 화면 활성화와 비활성화를 넣어둔다
    //화면 접근을 일단 비활성화
    ubox_disable_screen();

    //???
    ubox_set_tiles(tiles);
    ubox_set_tiles_colors(tiles_colors);

    //특정 타일로 화면을 다 그림. arguemnt는 타일 인덱스.
    ubox_fill_screen(WHITESPACE_TILE);
    //hello, world 쓰기
    put_text(11, 11, "HELLO, WORLD!!");
    //화면 접근을 활성화
    ubox_enable_screen();


    //다 돌았으니 마지막 출력물을 보여주는 상태로 유지
    while(1)
    {
        ubox_wait();
    }

}