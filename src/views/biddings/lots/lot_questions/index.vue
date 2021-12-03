<style scoped lang="scss">
</style>

<template lang="pug">
  .container.mt-2
    .card.slim.mb-2
      ul.mb-0
        li.list-item.row.p-1(v-for="lot_question in lot_questions", key="lot_question.question", @click="editLotQuestionPath(lot_question)")
          .container
            .list-title
              | {{ lot_question.question }}
            span(v-if="lot_question.answer")
              | {{ lot_question.answer }}
            span(v-else)
              | {{ $t('.waiting_answer') }}
</template>

<script>
  export default {
    name: 'lotQuestions',

    data () {
      return {
        i18nScope: 'biddings.lots.lot_questions.index',
        lot_questions: null,
        isLoading: true
      }
    },

    methods: {
      fetch() {
        this.isLoading = true

        return this.$http.get('/cooperative/biddings/' + this.biddingId + '/lots/' + this.lotId + '/lot_questions')
          .then((response) => {
            this.lot_questions = response.data
            this.isLoading = false

          }).catch((_err) => {
            this.error = _err
            console.error(_err)
          })
      },

      editLotQuestionPath(lot_question) {
        if (lot_question.answer != null) {
          return '#!'
        }
        
        this.$router.push({ name: 'EditLotQuestion', params: { bidding_id: this.biddingId, lot_id: this.lotId, id: lot_question.id } })
      },

      parseRoute() {
        this.biddingId = this.$params.asInteger(this.$route.params.bidding_id)
        this.lotId = this.$params.asInteger(this.$route.params.lot_id)
      },

      init() {
        this.parseRoute()
        this.fetch()
      }      
    },

    created: function () {
      this.init();
    }
  }
</script>
