<style scoped lang="scss">
  .container {
    width: 100%;
  }
</style>

<template lang="pug">
.container
  template(v-if="bidding.status === 'under_review'")
    router-link.button.button-primary.router-link.mt-2.u-full-width(:to="{ name: 'NewLotAttachmentRequest', params: { bidding_id: this.biddingId, lot_id: this.lotId } }")
      | {{ $t('.button.new_request') }}

  .card.slim.mb-2.mt-2(v-if="this.lotAttachmentsCount > 0")
    ul.mb-0
      li.list-item.row.p-1(v-for="lotAttachment in this.lotAttachments")
        .container
          .list-title.mb-1 {{ lotAttachment.supplier_name }}

          a.input-file.mb-1(:href="attachmentPath(lotAttachment.attachment_file)", target="_blank")
            i.fa.fa-download.mr-1.u-pull-left
            span.attachment-name {{ lotAttachment.attachment_filename }}

  span(v-if="this.lotAttachmentsCount == 0")
    | {{ $t('.no_lot_attachments') }}

</template>

<script>
  export default {
    name: 'lotAttachments',

    data () {
      return {
        i18nScope: 'biddings.lots.lot_attachments.index',
        lotAttachments: null,
        lotAttachmentsCount: 0,
        isLoading: true,
        bidding: {},

        tabs: [
          {
            route: { name: 'bidding', params: {} },
            icon: 'fa-file',
            text: this.$t('models.bidding.one'),
            active: false,
          },

          {
            route: { name: 'lots', params: { bidding_id: null } },
            icon: 'fa-list',
            text: this.$t('biddings.lots.index.tabs.lots'),
            active: true,
          },

          {
            route: { name: 'invites', params: {} },
            icon: 'fa-envelope',
            text: this.$t('biddings.lots.index.tabs.invites'),
            active: false,
          }
        ]
      }
    },

    methods: {
      fetch() {
        this.isLoading = true

        return this.$http.get('/cooperative/biddings/' + this.biddingId + '/lots/' + this.lotId + '/lot_attachments')
          .then((response) => {
            this.lotAttachments = response.data
            this.lotAttachmentsCount = this.lotAttachments.length
            this.isLoading = false

          }).catch((_err) => {
            this.error = _err
            console.error(_err)
          })
      },

      getBidding() {
        return this.$http.get('/cooperative/biddings/' + this.biddingId)
          .then((response) => {
            this.bidding = response.data
            return response
          }).catch((_err) => {
            this.error = _err
            console.error(_err)
          })
      },

      attachmentPath(attachment) {
        if(typeof attachment === 'undefined') return
        return app.secrets.api.host + attachment.url
      },

      parseRoute() {
        this.biddingId = this.$params.asInteger(this.$route.params.bidding_id)
        this.lotId = this.$params.asInteger(this.$route.params.lot_id)
      },

      updateTabsRoutes() {
        this.tabs[0].route.params = { id: this.biddingId }
        this.tabs[1].route.params = { bidding_id: this.biddingId }
        this.tabs[2].route.params = { bidding_id: this.biddingId, lot_id: this.lotId }

        this.$emit('tabChanged', this.tabs)
      },

      updateTitle() {
        this.$emit('navbarTitleChanged', this.$t('.title'))
      },

      init() {
        this.parseRoute()
        this.updateTitle()
        this.updateTabsRoutes()
        this.getBidding()
        this.fetch()
      }      
    },

    created: function () {
      this.init();
    }
  }
</script>
