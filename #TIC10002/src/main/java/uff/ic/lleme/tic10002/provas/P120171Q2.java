package uff.ic.lleme.tic10002.provas;

public class P120171Q2 {

    private class No {

        private int conteudo;
        private No proximo;

        public No(int conteudo) {
            this.conteudo = conteudo;
        }
    }

    private No primeiro = null;
    private int tamanho = 0;

    public void incluir(int elemento) {
        No novo = new No(elemento);
        novo.proximo = primeiro;
        primeiro = novo;
        tamanho++;
    }

    public P120171Q2 obter(int n) {
        P120171Q2 selecao = new P120171Q2();
        return obter(selecao, primeiro, 0, n);
    }

    public P120171Q2 obter(P120171Q2 selecao, No no, int i, int n) {
        int posInvertida = tamanho - i - 1;
        if (posInvertida >= 0) {
            if (posInvertida < n)
                selecao.incluir(no.conteudo);
            obter(selecao, no.proximo, n, i++);
        }
        return selecao;
    }
}
