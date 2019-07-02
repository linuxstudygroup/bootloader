
void bootmain(void){
    char str[] = "Hello world!";
    char *dst = (char*)0xb8000;
    int i = 0;
    for(i = 0; str[i] != (char)0; i++){
        *dst = str[i];
        dst++;
        *dst = (char)0x01;
        dst++;
    }
    while(1);
}
